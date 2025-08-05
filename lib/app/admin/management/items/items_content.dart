import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/widgets/ui/table/allnimall_table.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_dialog.dart';
import 'package:allnimall_store/src/core/utils/number_formatter.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/app/admin/management/items/widgets/item_form_sheet.dart';

class ItemsContent extends ConsumerStatefulWidget {
  const ItemsContent({super.key});

  @override
  ConsumerState<ItemsContent> createState() => _ItemsContentState();
}

class _ItemsContentState extends ConsumerState<ItemsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadProducts();
    });
  }

  List<Product> get _filteredItems {
    final state = ref.watch(managementProvider);
    if (state is! ProductsLoaded) return [];

    // Filter hanya untuk items (product_type = 'item')
    return state.products.where((p) => p.isItem).toList();
  }

  Future<void> _editItem(Product item) async {
    openSheet(
      context: context,
      builder: (context) => ItemFormSheet(item: item),
      position: OverlayPosition.right,
    );
  }

  Future<void> _deleteItem(Product item) async {
    await AllnimallDialog.show(
      context: context,
      title: 'Hapus Produk',
      content:
          'Apakah Anda yakin ingin menghapus produk "${item.name}"? Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () async {
        try {
          await SupabaseService.softDeleteProduct(item.id);

          // Reload products after deletion
          ref.read(managementProvider.notifier).loadProducts();

          // Show success toast
          if (mounted) {
            showToast(
              context: context,
              builder: (context, overlay) => SurfaceCard(
                child: Basic(
                  title: const Text('Berhasil'),
                  content: const Text('Produk berhasil dihapus'),
                  trailing: AllnimallButton.primary(
                    onPressed: () => overlay.close(),
                    child: const Text('Tutup'),
                  ),
                ),
              ),
              location: ToastLocation.topCenter,
            );
          }
        } catch (e) {
          // Show error toast
          if (mounted) {
            showToast(
              context: context,
              builder: (context, overlay) => SurfaceCard(
                child: Basic(
                  title: const Text('Error'),
                  content: Text('Gagal menghapus produk: ${e.toString()}'),
                  trailing: AllnimallButton.primary(
                    onPressed: () => overlay.close(),
                    child: const Text('Tutup'),
                  ),
                ),
              ),
              location: ToastLocation.topCenter,
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managementProvider);

    if (state is ManagementLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ManagementError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text('Error loading products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(state.message,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.secondaryText)),
            const SizedBox(height: 24),
            AllnimallButton.primary(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadProducts(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }
    if (state is ProductsLoaded) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 131,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined,
                      size: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text('Kelola Produk',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  AllnimallButton.primary(
                    onPressed: () {
                      openSheet(
                        context: context,
                        builder: (context) => const ItemFormSheet(),
                        position: OverlayPosition.right,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Text('Tambah Produk',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            // Content section with fixed height
            Expanded(
              child: _filteredItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: AppColors.secondaryText),
                          SizedBox(height: 16),
                          Text('Belum ada produk',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryText)),
                          SizedBox(height: 8),
                          Text('Tambahkan produk pertama Anda',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText)),
                        ],
                      ),
                    )
                  : AllnimallTable(
                      scrollable: false,
                      minWidth: 1200, // Set minimum width untuk tabel
                      headers: [
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Produk'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Kode'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Kategori'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Stok'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Harga Jual'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Harga Beli'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Berat'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Diskon'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Status'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text(''),
                        ).build(context),
                      ],
                      rows: _filteredItems.map((item) {
                        return TableRow(
                          cells: [
                            // Product info
                            AllnimallTableCell(
                              expanded: false,
                              width: 350, // Lebar tetap untuk kolom produk
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Row(
                                children: [
                                  // Avatar/Icon
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        item.name.substring(0, 1).toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ).build(context),
                            // Code
                            AllnimallTableCell(
                              expanded: false,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                item.code ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ).build(context),
                            // Category
                            AllnimallTableCell(
                              expanded: false,
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                item.categoryName ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ).build(context),
                            // Stock
                            AllnimallTableCell(
                              expanded: false,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                NumberFormatter.formatStock(item.stock),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: item.stock > 0
                                      ? AppColors.primary
                                      : AppColors.error,
                                ),
                              ),
                            ).build(context),
                            // Selling Price
                            AllnimallTableCell(
                              expanded: false,
                              width: 140,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                NumberFormatter.formatCurrency(item.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ).build(context),
                            // Purchase Price
                            AllnimallTableCell(
                              expanded: false,
                              width: 140,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                NumberFormatter.formatCurrency(
                                    item.purchasePrice),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ).build(context),
                            // Weight
                            AllnimallTableCell(
                              expanded: false,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                item.formattedWeight,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ).build(context),
                            // Discount
                            AllnimallTableCell(
                              expanded: false,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: item.discountValue > 0
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.error
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${item.discountValue.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.secondaryText,
                                      ),
                                    ),
                            ).build(context),
                            // Status
                            AllnimallTableCell(
                              expanded: false,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: item.isActive
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.isActive ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: item.isActive
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ),
                            ).build(context),
                            // Actions
                            AllnimallTableCell(
                              expanded: false,
                              width: 140, // Lebar lebih besar untuk cell aksi
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: AllnimallTableActions(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                actions: [
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: AllnimallIconButton.ghost(
                                      size: 28,
                                      icon: const Icon(Icons.edit, size: 14),
                                      onPressed: () => _editItem(item),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: AllnimallIconButton.ghost(
                                      size: 28,
                                      icon: const Icon(Icons.delete, size: 14),
                                      onPressed: () => _deleteItem(item),
                                    ),
                                  ),
                                ],
                              ),
                            ).build(context),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
