import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart' as material;
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/widgets/ui/table/allnimall_table.dart';

class ProductsContent extends ConsumerStatefulWidget {
  const ProductsContent({super.key});

  @override
  ConsumerState<ProductsContent> createState() => _ProductsContentState();
}

class _ProductsContentState extends ConsumerState<ProductsContent> {
  @override
  void initState() {
    super.initState();
    // Load products when widget is initialized
    material.WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final managementState = ref.watch(managementProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 24,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Kelola Produk Pet Shop',
                style: _getSystemFont(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              AllnimallButton.primary(
                onPressed: () => _showAddProductDialog(context),
                child: const Text('Tambah Produk'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content based on state
          _buildContent(managementState),
        ],
      ),
    );
  }

  Widget _buildContent(ManagementState state) {
    if (state is ManagementLoading) {
      return Center(
        child: material.CircularProgressIndicator(),
      );
    } else if (state is ManagementError) {
      return Center(
        child: Column(
          children: [
            material.Icon(
              Icons.error_outline,
              size: 48,
              color: material.Colors.red,
            ),
            material.SizedBox(height: 16),
            Text(
              'Terjadi kesalahan: ${state.message}',
              style: _getSystemFont(
                fontSize: 16,
                color: material.Colors.red,
              ),
            ),
            material.SizedBox(height: 16),
            AllnimallButton.primary(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadProducts(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    } else if (state is ProductsLoaded) {
      return _buildProductsTable(state.products);
    } else {
      return Center(
        child: Text('Tidak ada data'),
      );
    }
  }

  Widget _buildProductsTable(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          children: [
            material.Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: material.Colors.grey[400],
            ),
            material.SizedBox(height: 16),
            Text(
              'Belum ada produk',
              style: _getSystemFont(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: material.Colors.grey[600],
              ),
            ),
            material.SizedBox(height: 8),
            Text(
              'Tambahkan produk pertama Anda',
              style: _getSystemFont(
                fontSize: 14,
                color: material.Colors.grey[600],
              ),
            ),
            material.SizedBox(height: 16),
            AllnimallButton.primary(
              onPressed: () => _showAddProductDialog(context),
              child: const Text('Tambah Produk Pertama'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search and filter bar
        Row(
          children: [
            Expanded(
              child: TextField(
                placeholder: const Text('Cari produk...'),
                features: const [
                  InputFeature.clear(),
                ],
              ),
            ),
            material.SizedBox(width: 12),
            AllnimallIconButton.outline(
              onPressed: () => _showFilterDialog(context),
              icon: const Icon(Icons.filter_list),
            ),
          ],
        ),
        material.SizedBox(height: 16),

        // Products table
        AllnimallTable(
          headers: [
            AllnimallTableCell(
              child: const Text('Gambar'),
              isHeader: true,
            ).build(context),
            AllnimallTableCell(
              child: const Text('Nama Produk'),
              isHeader: true,
            ).build(context),
            AllnimallTableCell(
              child: const Text('Kategori'),
              isHeader: true,
            ).build(context),
            AllnimallTableCell(
              child: const Text('Harga'),
              isHeader: true,
              alignment: Alignment.centerRight,
            ).build(context),
            AllnimallTableCell(
              child: const Text('Stok'),
              isHeader: true,
              alignment: Alignment.center,
            ).build(context),
            AllnimallTableCell(
              child: const Text('Status'),
              isHeader: true,
              alignment: Alignment.center,
            ).build(context),
            AllnimallTableCell(
              child: const Text('Aksi'),
              isHeader: true,
              alignment: Alignment.center,
            ).build(context),
          ],
          rows: products
              .map((product) => TableRow(
                    cells: [
                      // Image
                      AllnimallTableCell(
                        child: _buildProductImage(product),
                        alignment: Alignment.center,
                      ).build(context),
                      // Name
                      AllnimallTableCell(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: _getSystemFont(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (product.description != null)
                              Text(
                                product.description!,
                                style: _getSystemFont(
                                  fontSize: 12,
                                  color: material.Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: material.TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ).build(context),
                      // Category
                      AllnimallTableCell(
                        child: Text(
                          product.categoryName ?? 'Tidak ada kategori',
                          style: _getSystemFont(
                            fontSize: 12,
                            color: material.Colors.grey[600],
                          ),
                        ),
                      ).build(context),
                      // Price
                      AllnimallTableCell(
                        child: Text(
                          product.formattedPrice,
                          style: _getSystemFont(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                      ).build(context),
                      // Stock
                      AllnimallTableCell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            material.Icon(
                              Icons.inventory_2_outlined,
                              size: 12,
                              color: product.stock <= product.minStock
                                  ? material.Colors.red
                                  : material.Colors.green,
                            ),
                            material.SizedBox(width: 4),
                            Text(
                              product.formattedStock,
                              style: _getSystemFont(
                                fontSize: 12,
                                color: product.stock <= product.minStock
                                    ? material.Colors.red
                                    : material.Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                      ).build(context),
                      // Status
                      AllnimallTableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: product.isActive
                                ? material.Colors.green[50]
                                : material.Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: product.isActive
                                  ? material.Colors.green
                                  : material.Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            product.isActive ? 'Aktif' : 'Nonaktif',
                            style: _getSystemFont(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: product.isActive
                                  ? material.Colors.green[700]
                                  : material.Colors.grey[600],
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                      ).build(context),
                      // Actions
                      AllnimallTableCell(
                        child: AllnimallTableActions(
                          actions: [
                            AllnimallIconButton.outline(
                              onPressed: () =>
                                  _showEditProductDialog(context, product),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                            ),
                            AllnimallIconButton.destructive(
                              onPressed: () =>
                                  _showDeleteConfirmation(context, product),
                              icon: const Icon(Icons.delete_outline, size: 16),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                      ).build(context),
                    ],
                  ))
              .toList(),
          resizable: true,
          minHeight: 400,
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.imageUrl != null) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: material.Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: material.Image.network(
            product.imageUrl!,
            fit: material.BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: material.Colors.grey[100],
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  size: 20,
                  color: material.Colors.grey,
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: material.Colors.grey[100],
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: material.Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.image_not_supported_outlined,
          size: 20,
          color: material.Colors.grey,
        ),
      );
    }
  }

  void _showAddProductDialog(BuildContext context) {
    material.showDialog(
      context: context,
      builder: (context) => material.AlertDialog(
        title: const Text('Tambah Produk Baru'),
        content: material.SizedBox(
          width: 400,
          child: const Text('Form tambah produk akan ditampilkan di sini'),
        ),
        actions: [
          AllnimallButton.outline(
            onPressed: () => material.Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          AllnimallButton.primary(
            onPressed: () {
              material.Navigator.of(context).pop();
              _showToast('Produk berhasil ditambahkan');
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    material.showDialog(
      context: context,
      builder: (context) => material.AlertDialog(
        title: const Text('Edit Produk'),
        content: material.SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit produk: ${product.name}'),
              material.SizedBox(height: 16),
              const Text('Form edit produk akan ditampilkan di sini'),
            ],
          ),
        ),
        actions: [
          AllnimallButton.outline(
            onPressed: () => material.Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          AllnimallButton.primary(
            onPressed: () {
              material.Navigator.of(context).pop();
              _showToast('Produk berhasil diperbarui');
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    material.showDialog(
      context: context,
      builder: (context) => material.AlertDialog(
        title: const Text('Hapus Produk'),
        content: Text(
          'Apakah Anda yakin ingin menghapus produk "${product.name}"?',
        ),
        actions: [
          AllnimallButton.outline(
            onPressed: () => material.Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          AllnimallButton.destructive(
            onPressed: () {
              material.Navigator.of(context).pop();
              _deleteProduct(product.id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    material.showDialog(
      context: context,
      builder: (context) => material.AlertDialog(
        title: const Text('Filter Produk'),
        content: material.SizedBox(
          width: 300,
          child: const Text('Filter options akan ditampilkan di sini'),
        ),
        actions: [
          AllnimallButton.outline(
            onPressed: () => material.Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          AllnimallButton.primary(
            onPressed: () {
              material.Navigator.of(context).pop();
              _showToast('Filter diterapkan');
            },
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  void _deleteProduct(String productId) async {
    try {
      await ref.read(managementProvider.notifier).deleteProduct(productId);
      _showToast('Produk berhasil dihapus');
    } catch (e) {
      _showToast('Gagal menghapus produk: $e');
    }
  }

  void _showToast(String message) {
    showToast(
      context: context,
      builder: (context, overlay) {
        return SurfaceCard(
          child: Basic(
            title: Text(message),
            leading: const Icon(Icons.check_circle_outline),
          ),
        );
      },
    );
  }

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
}
