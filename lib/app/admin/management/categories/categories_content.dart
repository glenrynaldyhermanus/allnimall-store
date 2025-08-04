import 'package:allnimall_store/app/admin/management/categories/widgets/category_form_sheet.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_dialog.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/widgets/ui/table/allnimall_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CategoriesContent extends ConsumerStatefulWidget {
  const CategoriesContent({super.key});

  @override
  ConsumerState<CategoriesContent> createState() => _CategoriesContentState();
}

class _CategoriesContentState extends ConsumerState<CategoriesContent> {
  @override
  void initState() {
    super.initState();
    // Auto-load categories when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadCategories();
    });
  }

  Future<void> _editCategory(Map<String, dynamic> category) async {
    openSheet(
      context: context,
      builder: (context) => CategoryFormSheet(category: category),
      position: OverlayPosition.right,
    );
  }

  Future<void> _deleteCategory(Map<String, dynamic> category) async {
    await AllnimallDialog.show(
      context: context,
      title: 'Hapus Kategori',
      content:
          'Apakah Anda yakin ingin menghapus kategori "${category['name']}"? Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () async {
        try {
          await SupabaseService.softDeleteCategory(category['id']);

          // Reload categories after deletion
          ref.read(managementProvider.notifier).loadCategories();

          // Show success toast
          if (mounted) {
            showToast(
              context: context,
              builder: (context, overlay) => SurfaceCard(
                child: Basic(
                  title: const Text('Berhasil'),
                  content: const Text('Kategori berhasil dihapus'),
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
                  content: Text('Gagal menghapus kategori: ${e.toString()}'),
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
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            AllnimallButton.primary(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadCategories(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (state is CategoriesLoaded) {
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
                  const Icon(
                    Icons.category_outlined,
                    size: 24,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Kelola Kategori',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  AllnimallButton.primary(
                    onPressed: () {
                      openSheet(
                        context: context,
                        builder: (context) => const CategoryFormSheet(),
                        position: OverlayPosition.right,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Text(
                        'Tambah Kategori',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content section with fixed height
            Expanded(
              child: state.categories.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 64,
                            color: AppColors.secondaryText,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada kategori',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tambahkan kategori pertama Anda',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    )
                  : AllnimallTable(
                      scrollable: false,
                      minWidth: 800,
                      headers: [
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Kategori'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Deskripsi'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Jumlah Produk'),
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
                      rows: state.categories.map((category) {
                        final colors = [
                          Colors.orange,
                          Colors.blue,
                          Colors.green,
                          Colors.red,
                          Colors.purple,
                          Colors.teal,
                          Colors.indigo,
                          Colors.amber,
                        ];
                        final color = colors[
                            state.categories.indexOf(category) % colors.length];

                        return TableRow(
                          cells: [
                            // Category info
                            AllnimallTableCell(
                              expanded: false,
                              width: 300,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Row(
                                children: [
                                  // Avatar/Icon
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      Icons.category,
                                      color: color,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      category['name'] ?? 'Unknown Category',
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
                            // Description
                            AllnimallTableCell(
                              expanded: false,
                              width: 250,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                category['description'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ).build(context),
                            // Product Count
                            AllnimallTableCell(
                              expanded: false,
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                '${category['product_count'] ?? 0} produk',
                                style: const TextStyle(
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
                                  color: (category['is_active'] ?? true)
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  (category['is_active'] ?? true)
                                      ? 'Aktif'
                                      : 'Nonaktif',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: (category['is_active'] ?? true)
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ),
                            ).build(context),
                            // Actions
                            AllnimallTableCell(
                              expanded: false,
                              width: 140,
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
                                      onPressed: () => _editCategory(category),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: AllnimallIconButton.ghost(
                                      size: 28,
                                      icon: const Icon(Icons.delete, size: 14),
                                      onPressed: () =>
                                          _deleteCategory(category),
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
