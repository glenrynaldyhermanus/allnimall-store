import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_select.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/feedback/product_loading.dart';
import 'package:allnimall_store/src/providers/cashier_provider.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'service_selection_dialog.dart';

class PosProductWidget extends ConsumerStatefulWidget {
  const PosProductWidget({super.key});

  @override
  ConsumerState<PosProductWidget> createState() => _PosProductWidgetState();
}

class _PosProductWidgetState extends ConsumerState<PosProductWidget> {
  // Products State
  List<Product> products = [];
  bool isLoadingProducts = true;

  // Search and Filter State
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
  String _selectedType = 'all'; // 'all', 'item', 'service'
  List<String> categories = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterProducts);

    // Load products data with delay to avoid conflicts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadProductsData().catchError((e) {
          // Error loading products data
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProductsData() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isLoadingProducts = true;
    });

    try {
      // Check if user is authenticated

      // Get store ID and local storage data
      final storeId = await LocalStorageService.getStoreId();

      if (storeId == null) {
        throw Exception('Store ID not found in local storage');
      }

      // Use management provider to load products
      await ref.read(managementProvider.notifier).loadProducts();

      // Get products from management state
      final managementState = ref.read(managementProvider);
      if (managementState is ProductsLoaded) {
        if (mounted) {
          setState(() {
            products = managementState.products;
            isLoadingProducts = false;
          });
          _updateCategories();
          _filterProducts();
        }
      } else if (managementState is ManagementError) {
        throw Exception(managementState.message);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingProducts = false;
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
                content: Text('Gagal memuat produk: $e'),
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

  void _updateCategories() {
    final categorySet = <String>{};
    for (final product in products) {
      if (product.categoryName != null && product.categoryName!.isNotEmpty) {
        categorySet.add(product.categoryName!);
      }
    }
    categories = categorySet.toList()..sort();
  }

  void _filterProducts() {
    final searchTerm = _searchController.text.toLowerCase();
    final categoryFilter = selectedCategory;
    final typeFilter = _selectedType;

    filteredProducts = products.where((product) {
      // Search filter
      final matchesSearch = product.name.toLowerCase().contains(searchTerm) ||
          (product.code?.toLowerCase().contains(searchTerm) ?? false) ||
          (product.barcode?.toLowerCase().contains(searchTerm) ?? false);

      // Category filter
      final matchesCategory = categoryFilter == null ||
          categoryFilter == 'all' ||
          product.categoryName == categoryFilter;

      // Type filter
      final matchesType = typeFilter == 'all' ||
          (typeFilter == 'item' && product.isItem) ||
          (typeFilter == 'service' && product.isService);

      return matchesSearch && matchesCategory && matchesType;
    }).toList();

    // Debug: Show all products and their types
    debugPrint('🛒 [PosProductWidget] All products:');
    int serviceCount = 0;
    int itemCount = 0;
    for (final product in products) {
      debugPrint(
          '  - ${product.name}: type=${product.productType}, isService=${product.isService}, duration=${product.durationMinutes}');
      if (product.isService) serviceCount++;
      if (product.isItem) itemCount++;
    }
    debugPrint('🛒 [PosProductWidget] Total products: ${products.length}');
    debugPrint('🛒 [PosProductWidget] Service products: $serviceCount');
    debugPrint('🛒 [PosProductWidget] Item products: $itemCount');
    debugPrint(
        '🛒 [PosProductWidget] Filtered products: ${filteredProducts.length}');
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      selectedCategory = category;
    });
    _filterProducts();
  }

  void _onTypeChanged(String type) {
    if (_selectedType != type) {
      setState(() {
        _selectedType = type;
      });
      _filterProducts();
    }
  }

  Future<void> _addToCartWithAPI(Product product) async {
    debugPrint(
        '🛒 [PosProductWidget] _addToCartWithAPI called for product: ${product.name}');
    debugPrint('🛒 [PosProductWidget] Product isService: ${product.isService}');
    debugPrint('🛒 [PosProductWidget] Product type: ${product.productType}');
    debugPrint(
        '🛒 [PosProductWidget] Product duration: ${product.durationMinutes}');

    try {
      if (product.isService) {
        debugPrint(
            '🛒 [PosProductWidget] Product is service, showing dialog...');
        // Show service selection dialog for services
        await _showServiceSelectionDialog(product);
      } else {
        debugPrint(
            '🛒 [PosProductWidget] Product is item, adding directly to cart...');
        // Add product directly to cart
        await ref.read(cashierProvider.notifier).addToCart(product.id, 1);

        // Show success toast
        if (mounted) {
          showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                child: Basic(
                  title: const Text('Berhasil'),
                  content: Text('${product.name} ditambahkan ke keranjang'),
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
    } catch (e) {
      debugPrint('❌ [PosProductWidget] Error in _addToCartWithAPI: $e');
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('Error'),
                content: Text('Gagal menambahkan ke keranjang: $e'),
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

  Future<void> _showServiceSelectionDialog(Product product) async {
    debugPrint(
        '🛒 [PosProductWidget] _showServiceSelectionDialog called for product: ${product.name}');

    try {
      // Show proper service booking modal
      await showDialog(
        context: context,
        builder: (context) => ServiceSelectionDialog(
          product: product,
          onServiceSelected: (bookingData) async {
            debugPrint(
                '🛒 [PosProductWidget] onServiceSelected called with data: $bookingData');
            try {
              // Add service to cart with booking details using CashierProvider
              await ref.read(cashierProvider.notifier).addServiceToCart(
                    productId: bookingData['productId'],
                    bookingDate: bookingData['bookingDate'],
                    bookingTime: bookingData['bookingTime'],
                    durationMinutes: bookingData['durationMinutes'],
                    assignedStaffId: bookingData['assignedStaffId'],
                    customerNotes: bookingData['customerNotes'],
                  );

              // Show success toast
              if (mounted) {
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return SurfaceCard(
                      child: Basic(
                        title: const Text('Berhasil'),
                        content: Text(
                            '${product.name} ditambahkan ke keranjang dengan booking'),
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
            } catch (e) {
              debugPrint('❌ [PosProductWidget] Error in onServiceSelected: $e');
              if (mounted) {
                showToast(
                  context: context,
                  builder: (context, overlay) {
                    return SurfaceCard(
                      child: Basic(
                        title: const Text('Error'),
                        content:
                            Text('Gagal menambahkan service ke keranjang: $e'),
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
          },
        ),
      );

      debugPrint('🛒 [PosProductWidget] Service booking modal closed');
    } catch (e) {
      debugPrint('❌ [PosProductWidget] Error showing dialog: $e');
    }
  }

  Widget _buildProductImage(Product product) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.imageUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon(product);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.slate[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      );
    }
    return _buildPlaceholderIcon(product);
  }

  Widget _buildPlaceholderIcon(Product product) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: product.stock > 0 ? Colors.blue[50] : Colors.slate[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        product.isService ? Icons.schedule : Icons.pets,
        size: 24,
        color: product.stock > 0 ? Colors.blue[600] : Colors.slate[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Listen to management state changes
    ref.listen<ManagementState>(managementProvider, (previous, next) {
      if (next is ProductsLoaded) {
        setState(() {
          products = next.products;
          isLoadingProducts = false;
        });
        _updateCategories();
        _filterProducts();
      } else if (next is ManagementError) {
        setState(() {
          isLoadingProducts = false;
        });
        // Show error toast
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('Error'),
                content: Text('Gagal memuat produk: ${next.message}'),
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
      } else if (next is ManagementLoading) {
        setState(() {
          isLoadingProducts = true;
        });
      }
    });

    return Column(
      children: [
        // Search and Filter Section
        SurfaceCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Bar
              AllnimallTextInput(
                controller: _searchController,
                placeholder: 'Cari produk...',
                leading: const Icon(Icons.search),
              ),
              const SizedBox(height: 16),
              // Filter Row
              Row(
                children: [
                  // Category Filter
                  Expanded(
                    child: AllnimallSelect<String>(
                      value: selectedCategory,
                      onChanged: _onCategoryChanged,
                      placeholder: const Text('Semua Kategori'),
                      items: categories,
                      itemBuilder: (context, category) {
                        return Text(category);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Type Filter
                  Expanded(
                    child: AllnimallSelect<String>(
                      value: _selectedType,
                      onChanged: (value) => _onTypeChanged(value ?? 'all'),
                      placeholder: const Text('Semua Tipe'),
                      items: const ['all', 'item', 'service'],
                      itemBuilder: (context, type) {
                        String label;
                        switch (type) {
                          case 'all':
                            label = 'Semua Tipe';
                            break;
                          case 'item':
                            label = 'Produk';
                            break;
                          case 'service':
                            label = 'Jasa';
                            break;
                          default:
                            label = type;
                        }
                        return Text(label);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Products Grid
        Expanded(
          child: isLoadingProducts
              ? const ProductLoading()
              : products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.slate[100],
                          ),
                          const SizedBox(height: 16),
                          const Text('Tidak ada produk').muted().large(),
                          const SizedBox(height: 8),
                          const Text('Belum ada produk yang ditambahkan')
                              .muted()
                              .small(),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 120,
                            height: 36,
                            child: AllnimallButton.primary(
                              onPressed: _loadProductsData,
                              child: const Text(
                                'Muat Ulang',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : filteredProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.slate[100],
                              ),
                              const SizedBox(height: 16),
                              const Text('Produk tidak ditemukan')
                                  .muted()
                                  .large(),
                              const SizedBox(height: 8),
                              const Text(
                                      'Produk yang kamu cari tidak ditemukan')
                                  .muted()
                                  .small(),
                            ],
                          ),
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
                          itemCount: filteredProducts.length + 1,
                          itemBuilder: (context, index) {
                            // First item is always the "Add Product" placeholder
                            if (index == 0) {
                              return SurfaceCard(
                                padding: const EdgeInsets.all(12),
                                child: Clickable(
                                  onPressed: () {
                                    // TODO: Navigate to add product page
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.blue[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('Tambah Produk')
                                          .semiBold()
                                          .small(),
                                      const SizedBox(height: 4),
                                      const Text('Klik untuk menambah')
                                          .muted()
                                          .xSmall(),
                                    ],
                                  ),
                                ),
                              );
                            }

                            // Regular product items
                            final product = filteredProducts[index - 1];
                            return SurfaceCard(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildProductImage(product),
                                  const SizedBox(height: 8),
                                  Text(product.name).semiBold(),
                                  const SizedBox(height: 4),
                                  Text(product.formattedPrice).muted().small(),
                                  const SizedBox(height: 4),
                                  if (product.isService) ...[
                                    Text('Durasi: ${product.formattedDuration}')
                                        .muted()
                                        .xSmall(),
                                    const SizedBox(height: 2),
                                  ] else ...[
                                    Text('Stok: ${product.formattedStock}')
                                        .muted()
                                        .xSmall(),
                                    const SizedBox(height: 2),
                                  ],
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 32,
                                    child: AllnimallButton.primary(
                                      onPressed: (product.stock > 0 ||
                                              product.isService)
                                          ? () {
                                              debugPrint(
                                                  '🛒 [PosProductWidget] Button clicked for product: ${product.name}');
                                              debugPrint(
                                                  '🛒 [PosProductWidget] Product stock: ${product.stock}');
                                              debugPrint(
                                                  '🛒 [PosProductWidget] Product isService: ${product.isService}');
                                              _addToCartWithAPI(product);
                                            }
                                          : null,
                                      child: Text(
                                        product.isService
                                            ? 'Booking'
                                            : 'Tambah',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
        ),
      ],
    );
  }
}
