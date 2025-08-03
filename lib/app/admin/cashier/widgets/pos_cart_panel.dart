import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/widgets/ui/feedback/cart_loading.dart';
import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/usecases/get_cart_usecase.dart';
import 'package:allnimall_store/src/data/usecases/update_cart_quantity_usecase.dart';
import 'package:allnimall_store/src/data/repositories/pos_repository_impl.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';

class PosCartPanel extends StatefulWidget {
  final Function(String)? onRemoveFromCart;
  final Function(String, int)? onUpdateQuantity;
  final VoidCallback? onCheckout;

  const PosCartPanel({
    super.key,
    this.onRemoveFromCart,
    this.onUpdateQuantity,
    this.onCheckout,
  });

  @override
  State<PosCartPanel> createState() => _PosCartPanelState();
}

class _PosCartPanelState extends State<PosCartPanel> {
  List<CartItem> cartItems = [];
  bool isLoadingCart = true;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  Future<void> _loadCartData() async {
    if (!mounted) return;

    setState(() {
      isLoadingCart = true;
    });

    try {
      final posRepository = PosRepositoryImpl(SupabaseService.client);
      final getCartUseCase = GetCartUseCase(posRepository);

      final cartItemsList = await getCartUseCase.call();

      if (mounted) {
        setState(() {
          cartItems = cartItemsList;
          isLoadingCart = false;
        });
      }
    } catch (e) {
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
      final cartItem = cartItems.firstWhere((item) => item.id == cartItemId);
      final posRepository = PosRepositoryImpl(SupabaseService.client);
      final updateCartQuantityUseCase =
          UpdateCartQuantityUseCase(posRepository);

      await updateCartQuantityUseCase.call(cartItem.product.id, 0);

      // Reload cart data
      await _loadCartData();

      // Call parent callback
      widget.onRemoveFromCart?.call(cartItemId);
    } catch (e) {
      // Show error toast
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('Error'),
                content: Text('Gagal menghapus dari keranjang: $e'),
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

  Future<void> _updateQuantity(String cartItemId, int newQuantity) async {
    try {
      final cartItem = cartItems.firstWhere((item) => item.id == cartItemId);
      final posRepository = PosRepositoryImpl(SupabaseService.client);
      final updateCartQuantityUseCase =
          UpdateCartQuantityUseCase(posRepository);

      await updateCartQuantityUseCase.call(cartItem.product.id, newQuantity);

      // Reload cart data
      await _loadCartData();

      // Call parent callback
      widget.onUpdateQuantity?.call(cartItemId, newQuantity);
    } catch (e) {
      // Show error toast
      if (mounted) {
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
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  void _handleCheckout() {
    // Call parent callback if provided
    widget.onCheckout?.call();

    // TODO: Implement checkout logic here
    // - Navigate to payment page
    // - Process payment
    // - Clear cart after successful payment
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.slate[100]),
        ),
      ),
      child: Column(
        children: [
          const Text('Keranjang Belanja').bold().large,
          const SizedBox(height: 16),
          // Cart items
          Expanded(
            child: isLoadingCart
                ? const CartLoading()
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
                          return SurfaceCard(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(cartItem.product.name)
                                          .semiBold(),
                                    ),
                                    SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: AllnimallIconButton.ghost(
                                        onPressed: () =>
                                            _removeFromCart(cartItem.id),
                                        icon: const Icon(Icons.close, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text('Rp ${cartItem.product.price.toStringAsFixed(0)}')
                                        .muted()
                                        .small(),
                                    const Spacer(),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: AllnimallIconButton.ghost(
                                            onPressed: () => _updateQuantity(
                                                cartItem.id,
                                                cartItem.quantity - 1),
                                            icon: const Icon(Icons.remove,
                                                size: 16),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 40,
                                          child: Text('${cartItem.quantity}')
                                              .semiBold()
                                              .center(),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 32,
                                          height: 32,
                                          child: AllnimallIconButton.ghost(
                                            onPressed: () => _updateQuantity(
                                                cartItem.id,
                                                cartItem.quantity + 1),
                                            icon:
                                                const Icon(Icons.add, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Total: Rp ${cartItem.totalPrice.toStringAsFixed(0)}')
                                    .semiBold()
                                    .small(),
                              ],
                            ),
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
                    Text('Rp ${totalPrice.toStringAsFixed(0)}').h3().bold(),
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
