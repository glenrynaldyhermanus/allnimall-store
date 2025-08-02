import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:allnimall_store/app/cashier/widgets/pos_cart.dart';
import 'package:allnimall_store/app/cashier/widgets/pos_header.dart';
import 'package:allnimall_store/app/cashier/widgets/product_card.dart';
import 'package:allnimall_store/src/providers/cashier_provider.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/core/utils/responsive.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/widgets/app_sidebar.dart';

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  // Business, Store, and User data
  String _businessName = '';
  String _storeName = '';
  String _cashierName = '';

  // Helper function untuk menggunakan system font
  TextStyle _getSystemFont({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadBusinessAndStoreData();
  }

  Future<void> _loadBusinessAndStoreData() async {
    try {
      // Load business data
      final businessData = await LocalStorageService.getBusinessData();
      if (businessData != null) {
        setState(() {
          _businessName = businessData['name'] ?? 'Unknown Business';
        });
      }

      // Load store data
      final storeData = await LocalStorageService.getStoreData();
      if (storeData != null) {
        setState(() {
          _storeName = storeData['name'] ?? 'Unknown Store';
        });
      }

      // Load user data
      final userData = await LocalStorageService.getUserData();
      if (userData != null) {
        setState(() {
          _cashierName = userData['name'] ?? 'Unknown Staff';
        });
      }
    } catch (e) {
      //print('Error loading business/store data: $e');
    }
  }

  void _addToCart(Product product) {
    ref.read(cashierProvider.notifier).addToCart(product.id, 1);
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      // Remove item from cart
      final currentState = ref.read(cashierProvider);
      if (currentState is CashierLoaded &&
          index < currentState.cartItems.length) {
        final item = currentState.cartItems[index];
        ref.read(cashierProvider.notifier).updateCartQuantity(
              item.product.id,
              0,
            );
      }
    } else {
      final currentState = ref.read(cashierProvider);
      if (currentState is CashierLoaded &&
          index < currentState.cartItems.length) {
        final item = currentState.cartItems[index];
        ref.read(cashierProvider.notifier).updateCartQuantity(
              item.product.id,
              newQuantity,
            );
      }
    }
  }

  void _clearCart() {
    ref.read(cashierProvider.notifier).clearCart();
  }

  void _processPayment() {
    final currentState = ref.read(cashierProvider);
    if (currentState is CashierLoaded && currentState.cartItems.isNotEmpty) {
      // Navigate to payment page instead of showing dialog
      context.go('/payment');
    }
  }

  List<String> _getCategories(CashierLoaded state) {
    final categories = state.products
        .map((p) => p.categoryName ?? 'Uncategorized')
        .toSet()
        .toList();
    categories.insert(0, 'All');
    return categories;
  }

  List<Product> _getFilteredProducts(CashierLoaded state) {
    if (state.selectedCategory == 'all' || state.selectedCategory == 'All') {
      return state.products;
    }

    final filtered = state.products
        .where((p) => p.categoryName == state.selectedCategory)
        .toList();
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    
    final cashierState = ref.watch(cashierProvider);

    // Listen to cashier state changes
    ref.listen<CashierState>(cashierProvider, (previous, next) {
      if (next is CashierError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.message}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    if (cashierState is CashierInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(cashierProvider.notifier).loadProducts();
      });
      return const Center(child: CircularProgressIndicator());
    }

    if (cashierState is CashierLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (cashierState is CashierError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading data',
              style: _getSystemFont(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              cashierState.message,
              style: _getSystemFont(
                fontSize: 14,
                color:
                    AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(cashierProvider.notifier).loadProducts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (cashierState is CashierLoaded) {
      return Scaffold(
        body: Container(
          color: AppColors.surfaceBackground,
          child: Row(
            children: [
              // Sidebar - hanya tampil jika bukan web
              if (!Responsive.isWeb()) const AppSidebar(),
              // Main Content
              Expanded(
                child: Column(
                  children: [
                    // Page Header
                    PosHeader(
                      businessName: _businessName,
                      storeName: _storeName,
                      cashierName: _cashierName,
                    ),
                    // Content
                    Expanded(
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              // Products Section
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Search and Category Row
                                    Row(
                                      children: [
                                        // Search Field
                                        Expanded(
                                          flex: 2,
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              labelText: 'Search Pet Products',
                                              hintText: 'Type product name...',
                                              prefixIcon: Icon(Icons.search),
                                              border: OutlineInputBorder(),
                                            ),
                                            onChanged: (value) {
                                              ref
                                                  .read(
                                                      cashierProvider.notifier)
                                                  .searchProducts(value);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Category Filter
                                        Expanded(
                                          flex: 1,
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: cashierState
                                                        .selectedCategory ==
                                                    'all'
                                                ? 'All'
                                                : cashierState.selectedCategory,
                                            decoration: const InputDecoration(
                                              labelText: 'Category',
                                              border: OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                            ),
                                            isExpanded: true,
                                            items: _getCategories(cashierState)
                                                .map((category) {
                                              return DropdownMenuItem(
                                                value: category,
                                                child: Text(
                                                  category,
                                                  style: _getSystemFont(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              if (value != null) {
                                                ref
                                                    .read(cashierProvider
                                                        .notifier)
                                                    .filterByCategory(value);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    // Products Grid
                                    Expanded(
                                      child: Builder(
                                        builder: (context) {
                                          final filteredProducts =
                                              _getFilteredProducts(
                                                  cashierState);

                                          return GridView.builder(
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 4,
                                              childAspectRatio: 1.1,
                                              crossAxisSpacing: 16,
                                              mainAxisSpacing: 16,
                                            ),
                                            itemCount: filteredProducts.length,
                                            itemBuilder: (context, index) {
                                              final product =
                                                  filteredProducts[index];
                                              return ProductCard(
                                                product: product,
                                                onTap: () =>
                                                    _addToCart(product),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Cart Section
                              Expanded(
                                flex: 1,
                                child: PosCart(
                                  state: cashierState,
                                  onClearCart: _clearCart,
                                  onUpdateQuantity: _updateQuantity,
                                  onProcessPayment: _processPayment,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
