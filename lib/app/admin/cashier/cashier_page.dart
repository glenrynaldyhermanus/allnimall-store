import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/usecases/get_all_products_usecase.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:allnimall_store/src/data/repositories/management_repository_impl.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  List<Product> products = [];
  List<CartItem> cartItems = [];
  String? storeName;
  String? businessName;
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Load user, business, and store data
      final userData = await LocalStorageService.getUserData();
      final businessData = await LocalStorageService.getBusinessData();
      final storeData = await LocalStorageService.getStoreData();

      // Load products
      final managementRepository =
          ManagementRepositoryImpl(SupabaseService.client);
      final getAllProductsUseCase = GetAllProductsUseCase(managementRepository);
      final productsList = await getAllProductsUseCase.execute();

      setState(() {
        products = productsList.where((product) => product.isActive).toList();
        storeName = storeData?['name'] ?? 'Cabang';
        businessName = businessData?['name'] ?? 'Allnimall Pet Shop';
        userName = userData?['name'] ?? 'Staff';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  void _addToCart(Product product) {
    setState(() {
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingItemIndex != -1) {
        // Update quantity if item already exists
        final existingItem = cartItems[existingItemIndex];
        cartItems[existingItemIndex] = CartItem(
          id: existingItem.id,
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
          storeId: existingItem.storeId,
          createdAt: existingItem.createdAt,
        );
      } else {
        // Add new item to cart
        final newCartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          quantity: 1,
          storeId: product.storeId,
          createdAt: DateTime.now(),
        );
        cartItems.add(newCartItem);
      }
    });
  }

  void _removeFromCart(String cartItemId) {
    setState(() {
      cartItems.removeWhere((item) => item.id == cartItemId);
    });
  }

  void _updateQuantity(String cartItemId, int newQuantity) {
    setState(() {
      final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);
      if (itemIndex != -1) {
        final item = cartItems[itemIndex];
        if (newQuantity > 0) {
          cartItems[itemIndex] = CartItem(
            id: item.id,
            product: item.product,
            quantity: newQuantity,
            storeId: item.storeId,
            createdAt: item.createdAt,
          );
        } else {
          cartItems.removeAt(itemIndex);
        }
      }
    });
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        child: Row(
          children: [
            // Sidebar
            const Sidebar(),
            // Left side - Product grid
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.slate[100]),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(businessName ?? 'Allnimall Pet Shop').h1().bold(),
                        const Spacer(),
                        Text(storeName ?? 'Cabang').muted(),
                        const SizedBox(width: 16),
                        Text(userName ?? 'Staff').muted(),
                      ],
                    ),
                  ),
                  // Product grid
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.2,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Card(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.pets,
                                      size: 32,
                                      color: product.stock > 0
                                          ? Colors.blue[600]
                                          : Colors.slate[400],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(product.name).semiBold(),
                                    const SizedBox(height: 4),
                                    Text('Rp ${product.price.toStringAsFixed(0)}')
                                        .muted()
                                        .small(),
                                    const SizedBox(height: 4),
                                    Text('Stok: ${product.stock}')
                                        .muted()
                                        .xSmall(),
                                    const SizedBox(height: 8),
                                    AllnimallButton.primary(
                                      onPressed: product.stock > 0
                                          ? () => _addToCart(product)
                                          : null,
                                      child: const Text('Tambah'),
                                    ).constrained(height: 32),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            // Right side - Cart
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.slate[100]),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Keranjang Belanja').h2().bold(),
                    const SizedBox(height: 16),
                    // Cart items
                    Expanded(
                      child: cartItems.isEmpty
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
                                  const Text('Keranjang kosong')
                                      .muted()
                                      .large(),
                                  const SizedBox(height: 8),
                                  const Text(
                                          'Pilih produk untuk ditambahkan ke keranjang')
                                      .muted()
                                      .small(),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final cartItem = cartItems[index];
                                return Card(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(cartItem.product.name)
                                                .semiBold(),
                                          ),
                                          IconButton.ghost(
                                            onPressed: () =>
                                                _removeFromCart(cartItem.id),
                                            icon: const Icon(Icons.close),
                                            size: ButtonSize.small,
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
                                            children: [
                                              AllnimallIconButton.ghost(
                                                onPressed: () =>
                                                    _updateQuantity(cartItem.id,
                                                        cartItem.quantity - 1),
                                                icon: const Icon(Icons.remove),
                                              ),
                                              const SizedBox(width: 8),
                                              Text('${cartItem.quantity}')
                                                  .semiBold(),
                                              const SizedBox(width: 8),
                                              AllnimallIconButton.ghost(
                                                onPressed: () =>
                                                    _updateQuantity(cartItem.id,
                                                        cartItem.quantity + 1),
                                                icon: const Icon(Icons.add),
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
                    Card(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Text('Total:').semiBold(),
                              const Spacer(),
                              Text('Rp ${totalPrice.toStringAsFixed(0)}')
                                  .h3()
                                  .bold(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          AllnimallButton.primary(
                            onPressed: cartItems.isNotEmpty
                                ? () {
                                    // Checkout logic
                                  }
                                : null,
                            child: const Text('Bayar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
