import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/providers/cashier_provider.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:allnimall_store/src/core/utils/number_formatter.dart';

class PosCartPanel extends ConsumerStatefulWidget {
  const PosCartPanel({super.key});

  @override
  ConsumerState<PosCartPanel> createState() => _PosCartPanelState();
}

class _PosCartPanelState extends ConsumerState<PosCartPanel> {
  List<CartItem> cartItems = [];
  bool isLoadingCart = true;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    if (!mounted) return;

    debugPrint('🛒 [PosCartPanel] Mulai load cart data...');

    setState(() {
      isLoadingCart = true;
    });

    try {
      // Debug: Check if user is authenticated
      debugPrint('🔐 [PosCartPanel] Checking authentication...');
      final isAuthenticated = await SupabaseService.isUserAuthenticated();
      debugPrint('🔐 [PosCartPanel] Is authenticated: $isAuthenticated');

      if (!isAuthenticated) {
        throw Exception('User tidak terautentikasi');
      }

      // Debug: Get store ID
      debugPrint('🏪 [PosCartPanel] Getting store ID...');
      final storeId = await SupabaseService.getStoreId();
      debugPrint('🏪 [PosCartPanel] Store ID: $storeId');

      if (storeId == null) {
        throw Exception(
            'Store ID tidak ditemukan. Pastikan user sudah login dan memiliki akses ke store.');
      }

      // Debug: Check if cashier provider is initialized
      debugPrint('🔄 [PosCartPanel] Checking cashier provider state...');
      final cashierState = ref.read(cashierProvider);
      debugPrint(
          '🔄 [PosCartPanel] Current cashier state: ${cashierState.runtimeType}');

      if (cashierState is CashierInitial) {
        debugPrint('🔄 [PosCartPanel] Initializing cashier provider...');
        // Initialize cashier provider first
        await ref.read(cashierProvider.notifier).loadProducts();
        debugPrint('🔄 [PosCartPanel] Cashier provider initialized');
      }

      // Use cashier provider to load cart
      debugPrint('🛒 [PosCartPanel] Loading cart via cashier provider...');
      await ref.read(cashierProvider.notifier).loadCart();
      debugPrint('🛒 [PosCartPanel] Cart loaded via provider');

      // Get cart items from cashier state
      debugPrint('📊 [PosCartPanel] Getting updated cashier state...');
      final updatedCashierState = ref.read(cashierProvider);
      debugPrint(
          '📊 [PosCartPanel] Updated state type: ${updatedCashierState.runtimeType}');

      if (updatedCashierState is CashierLoaded) {
        debugPrint(
            '✅ [PosCartPanel] Successfully loaded cart with ${updatedCashierState.cartItems.length} items');
        if (mounted) {
          setState(() {
            cartItems = updatedCashierState.cartItems;
            isLoadingCart = false;
          });
        }
      } else if (updatedCashierState is CashierError) {
        debugPrint(
            '❌ [PosCartPanel] Cashier error: ${updatedCashierState.message}');
        throw Exception(updatedCashierState.message);
      } else {
        debugPrint(
            '❌ [PosCartPanel] Invalid state: ${updatedCashierState.runtimeType}');
        throw Exception('Gagal memuat keranjang: State tidak valid');
      }
    } catch (e) {
      debugPrint('❌ [PosCartPanel] Error in _loadCartData: $e');
      if (mounted) {
        setState(() {
          isLoadingCart = false;
        });
      }
      // Show error toast
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('Error'),
                content: Text('Gagal memuat keranjang: $e'),
                trailing: SizedBox(
                  height: 32,
                  child: AllnimallButton.ghost(
                    onPressed: () => overlay.close(),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  Future<void> _removeFromCart(String cartItemId) async {
    try {
      // Find the cart item to get product ID
      final cartItem = cartItems.firstWhere((item) => item.id == cartItemId);

      // Use updateCartQuantity with 0 to remove item
      await ref.read(cashierProvider.notifier).updateCartQuantity(
            cartItem.product.id,
            0,
          );
    } catch (e) {
      if (!mounted) return;

      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(
            child: Basic(
              title: const Text('Error'),
              content: Text('Gagal menghapus item: $e'),
              trailing: SizedBox(
                height: 32,
                child: AllnimallButton.ghost(
                  onPressed: () => overlay.close(),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _updateQuantity(String cartItemId, int newQuantity) async {
    try {
      // Find the cart item to get product ID
      final cartItem = cartItems.firstWhere((item) => item.id == cartItemId);

      await ref.read(cashierProvider.notifier).updateCartQuantity(
            cartItem.product.id,
            newQuantity,
          );
    } catch (e) {
      if (!mounted) return;

      showToast(
        context: context,
        builder: (context, overlay) {
          return SurfaceCard(
            child: Basic(
              title: const Text('Error'),
              content: Text('Gagal mengupdate jumlah: $e'),
              trailing: SizedBox(
                height: 32,
                child: AllnimallButton.ghost(
                  onPressed: () => overlay.close(),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _handleCheckout() {
    // TODO: Implement checkout logic here
    // - Navigate to payment page
    // - Process payment
    // - Clear cart after successful payment
  }

  Widget _buildCartItem(CartItem cartItem) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item Header
          Row(
            children: [
              // Item Type Icon
              Icon(
                cartItem.isService ? Icons.schedule : Icons.inventory,
                size: 16,
                color: cartItem.isService ? Colors.blue : Colors.green,
              ),
              const SizedBox(width: 8),
              // Item Name
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartItem.product.name).semiBold(),
                    if (cartItem.isService) ...[
                      const SizedBox(height: 4),
                      Text(
                        cartItem.bookingInfo.isNotEmpty
                            ? cartItem.bookingInfo
                            : 'Belum dijadwalkan',
                        style: TextStyle(
                          fontSize: 12,
                          color: cartItem.bookingInfo.isNotEmpty
                              ? Colors.blue
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Remove Button
              SizedBox(
                width: 32,
                height: 32,
                child: AllnimallIconButton.ghost(
                  onPressed: () => _removeFromCart(cartItem.id),
                  icon: const Icon(Icons.close, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Item Details
          Row(
            children: [
              Text(cartItem.product.formattedPrice).muted().small(),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: AllnimallIconButton.ghost(
                      onPressed: () =>
                          _updateQuantity(cartItem.id, cartItem.quantity - 1),
                      icon: const Icon(Icons.remove, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    child: Text(cartItem.formattedQuantity).semiBold().center(),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: AllnimallIconButton.ghost(
                      onPressed: () =>
                          _updateQuantity(cartItem.id, cartItem.quantity + 1),
                      icon: const Icon(Icons.add, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Service-specific details
          if (cartItem.isService && cartItem.bookingInfo.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: Colors.blue[700],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.bookingInfo,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                  if (cartItem.serviceDuration.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Durasi: ${cartItem.serviceDuration}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                  if (cartItem.customerNotes?.isNotEmpty == true) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Catatan: ${cartItem.customerNotes}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          const SizedBox(height: 4),
          Text('Total: ${cartItem.formattedTotalPrice}').semiBold().small(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to cashier state changes
    ref.listen<CashierState>(cashierProvider, (previous, next) {
      debugPrint(
          '🔄 [PosCartPanel] State changed from ${previous.runtimeType} to ${next.runtimeType}');

      if (next is CashierLoaded) {
        debugPrint(
            '✅ [PosCartPanel] CashierLoaded with ${next.cartItems.length} items');
        setState(() {
          cartItems = next.cartItems;
          isLoadingCart = false;
        });
      } else if (next is CashierError) {
        debugPrint('❌ [PosCartPanel] CashierError: ${next.message}');
        setState(() {
          isLoadingCart = false;
        });
        // Show error toast
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('Error'),
                content: Text('Gagal memuat keranjang: ${next.message}'),
                trailing: SizedBox(
                  height: 32,
                  child: AllnimallButton.ghost(
                    onPressed: () => overlay.close(),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      } else if (next is CashierLoading) {
        debugPrint('⏳ [PosCartPanel] CashierLoading');
        setState(() {
          isLoadingCart = true;
        });
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.slate[100]),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Keranjang Belanja').bold().large,
              const Spacer(),
              if (isLoadingCart)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(),
                ),
              // Debug button
              AllnimallIconButton.ghost(
                onPressed: () async {
                  try {
                    final isAuthenticated =
                        await SupabaseService.isUserAuthenticated();
                    final storeId = await SupabaseService.getStoreId();
                    final userData = await LocalStorageService.getUserData();
                    final roleData =
                        await LocalStorageService.getRoleAssignmentData();

                    if (!mounted) return;

                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Debug Info'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Authenticated: $isAuthenticated'),
                            Text('Store ID: $storeId'),
                            Text(
                                'User Data: ${userData != null ? "Available" : "Not available"}'),
                            Text(
                                'Role Data: ${roleData != null ? "Available" : "Not available"}'),
                            if (roleData != null) ...[
                              Text(
                                  'Store ID from role: ${roleData['store_id']}'),
                              Text('Role ID: ${roleData['role_id']}'),
                            ],
                          ],
                        ),
                        actions: [
                          AllnimallButton.primary(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Tutup'),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    if (!mounted) return;

                    showToast(
                      context: context,
                      builder: (toastContext, overlay) {
                        return SurfaceCard(
                          child: Basic(
                            title: const Text('Debug Error'),
                            content: Text('Error: $e'),
                            trailing: SizedBox(
                              height: 32,
                              child: AllnimallButton.ghost(
                                onPressed: () => overlay.close(),
                                child: const Text('Tutup'),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
                icon: const Icon(Icons.bug_report, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Cart items
          Expanded(
            child: isLoadingCart
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat keranjang...'),
                      ],
                    ),
                  )
                : cartItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: Colors.slate[100],
                            ),
                            const SizedBox(height: 16),
                            const Text('Keranjang kosong').muted().large(),
                            const SizedBox(height: 8),
                            const Text(
                                    'Pilih produk untuk ditambahkan ke keranjang')
                                .muted()
                                .small(),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final cartItem = cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildCartItem(cartItem),
                          );
                        },
                      ),
          ),
          // Cart summary
          SurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Total:').semiBold(),
                    const Spacer(),
                    Text(NumberFormatter.formatTotalPrice(totalPrice))
                        .h3()
                        .bold(),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 40,
                  child: AllnimallButton.primary(
                    onPressed: cartItems.isNotEmpty ? _handleCheckout : null,
                    child: const Text(
                      'Bayar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
