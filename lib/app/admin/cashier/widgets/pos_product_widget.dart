import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_select.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/feedback/product_loading.dart';
import 'package:allnimall_store/src/data/usecases/get_all_products_usecase.dart';
import 'package:allnimall_store/src/data/usecases/add_to_cart_usecase.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:allnimall_store/src/data/repositories/management_repository_impl.dart';
import 'package:allnimall_store/src/data/repositories/pos_repository_impl.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';

class PosProductWidget extends StatefulWidget {
  final VoidCallback? onCartUpdated;

  const PosProductWidget({
    super.key,
    this.onCartUpdated,
  });

  @override
  State<PosProductWidget> createState() => _PosProductWidgetState();
}

class _PosProductWidgetState extends State<PosProductWidget> {
  // Products State
  List<Product> products = [];
  bool isLoadingProducts = true;

  // Search and Filter State
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
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
      // Check Supabase connection

      // Check if user is authenticated

      final managementRepository =
          ManagementRepositoryImpl(SupabaseService.client);

      // Get store ID and local storage data
      final storeId = await LocalStorageService.getStoreId();

      if (storeId == null) {
        throw Exception('Store ID not found in local storage');
      }

      final getAllProductsUseCase = GetAllProductsUseCase(managementRepository);

      final productsList = await getAllProductsUseCase.execute();

      if (mounted) {
        setState(() {
          products = productsList;
          isLoadingProducts = false;
        });
        _updateCategories();
        _filterProducts();
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

  Future<void> _addToCartWithAPI(Product product) async {
    try {
      final posRepository = PosRepositoryImpl(SupabaseService.client);
      final addToCartUseCase = AddToCartUseCase(posRepository);

      await addToCartUseCase.call(product.id, 1);

      // Call callback to refresh cart
      widget.onCartUpdated?.call();

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
    } catch (e) {
      // Show error toast
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

  void _updateCategories() {
    categories = products
        .map((p) => p.categoryName)
        .where((c) => c != null && c.isNotEmpty)
        .map((c) => c!)
        .toSet()
        .toList();
  }

  void _filterProducts() {
    final searchQuery = _searchController.text.toLowerCase();

    // Prevent unnecessary setState calls
    final newFilteredProducts = products.where((product) {
      final matchesSearch =
          product.name.toLowerCase().contains(searchQuery) ||
              (product.code?.toLowerCase().contains(searchQuery) ?? false) ||
              (product.barcode?.toLowerCase().contains(searchQuery) ?? false);

      final matchesCategory = selectedCategory == null ||
          product.categoryName == selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();

    // Only update if the list actually changed
    if (!listEquals(filteredProducts, newFilteredProducts)) {
      setState(() {
        filteredProducts = newFilteredProducts;
      });
    }
  }

  void _onCategoryChanged(String? category) {
    if (selectedCategory != category) {
      setState(() {
        selectedCategory = category;
      });
      _filterProducts();
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
        Icons.pets,
        size: 24,
        color: product.stock > 0 ? Colors.blue[600] : Colors.slate[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Search Input
              Expanded(
                child: AllnimallTextInput(
                  controller: _searchController,
                  placeholder: 'Cari produk...',
                  leading: const Icon(Icons.search),
                  features: const [
                    InputFeature.clear(),
                  ],
                ),
              ),
              const Gap(16),
              // Category Filter
              SizedBox(
                width: 200,
                child: AllnimallSelect<String>(
                  value: selectedCategory,
                  onChanged: _onCategoryChanged,
                  placeholder: const Text('Semua Kategori'),
                  searchPlaceholder: 'Cari kategori...',
                  items: categories,
                  itemBuilder: (context, category) {
                    return Text(category);
                  },
                ),
              ),
            ],
          ),
        ),
        // Product grid
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
                                  Text('Rp ${product.price.toStringAsFixed(0)}')
                                      .muted()
                                      .small(),
                                  const SizedBox(height: 4),
                                  Text('Stok: ${product.stock}')
                                      .muted()
                                      .xSmall(),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 32,
                                    child: AllnimallButton.primary(
                                      onPressed: product.stock > 0
                                          ? () => _addToCartWithAPI(product)
                                          : null,
                                      child: const Text(
                                        'Tambah',
                                        style: TextStyle(color: Colors.white),
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
