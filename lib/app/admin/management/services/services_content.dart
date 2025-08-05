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
import 'package:allnimall_store/app/admin/management/services/widgets/service_form_sheet.dart';

class ServicesContent extends ConsumerStatefulWidget {
  const ServicesContent({super.key});

  @override
  ConsumerState<ServicesContent> createState() => _ServicesContentState();
}

class _ServicesContentState extends ConsumerState<ServicesContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadProducts();
    });
  }

  List<Product> get _filteredServices {
    final state = ref.watch(managementProvider);
    if (state is! ProductsLoaded) return [];

    // Filter hanya untuk services (product_type = 'service')
    return state.products.where((p) => p.isService).toList();
  }

  Future<void> _editService(Product service) async {
    openSheet(
      context: context,
      builder: (context) => ServiceFormSheet(service: service),
      position: OverlayPosition.right,
    );
  }

  Future<void> _deleteService(Product service) async {
    await AllnimallDialog.show(
      context: context,
      title: 'Hapus Jasa',
      content:
          'Apakah Anda yakin ingin menghapus jasa "${service.name}"? Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () async {
        try {
          await SupabaseService.softDeleteProduct(service.id);

          // Reload products after deletion
          ref.read(managementProvider.notifier).loadProducts();

          // Show success toast
          if (mounted) {
            showToast(
              context: context,
              builder: (context, overlay) => SurfaceCard(
                child: Basic(
                  title: const Text('Berhasil'),
                  content: const Text('Jasa berhasil dihapus'),
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
                  content: Text('Gagal menghapus jasa: ${e.toString()}'),
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
            const Text('Error loading services',
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
                  const Icon(Icons.miscellaneous_services_outlined,
                      size: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text('Kelola Jasa',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  AllnimallButton.primary(
                    onPressed: () {
                      openSheet(
                        context: context,
                        builder: (context) => const ServiceFormSheet(),
                        position: OverlayPosition.right,
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 12, right: 12),
                      child: Text('Tambah Jasa',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),

            // Content section with fixed height
            Expanded(
              child: _filteredServices.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.miscellaneous_services_outlined,
                              size: 64, color: AppColors.secondaryText),
                          SizedBox(height: 16),
                          Text('Belum ada jasa',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryText)),
                          SizedBox(height: 8),
                          Text('Tambahkan jasa pertama Anda',
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
                          child: Text('Jasa'),
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
                          child: Text('Durasi'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Harga'),
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
                      rows: _filteredServices.map((service) {
                        return TableRow(
                          cells: [
                            // Service info
                            AllnimallTableCell(
                              expanded: false,
                              width: 350, // Lebar tetap untuk kolom jasa
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Row(
                                children: [
                                  // Avatar/Icon
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        service.name
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      service.name,
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
                                service.code ?? '-',
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
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  service.serviceCategoryLabel,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ).build(context),
                            // Duration
                            AllnimallTableCell(
                              expanded: false,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                service.formattedDuration,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
                                ),
                              ),
                            ).build(context),
                            // Price
                            AllnimallTableCell(
                              expanded: false,
                              width: 140,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                NumberFormatter.formatCurrency(service.price),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ).build(context),
                            // Discount
                            AllnimallTableCell(
                              expanded: false,
                              width: 100,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: service.discountValue > 0
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppColors.error
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${service.discountValue.toStringAsFixed(0)}%',
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
                                  color: service.isActive
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  service.isActive ? 'Aktif' : 'Nonaktif',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: service.isActive
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
                                      onPressed: () => _editService(service),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: AllnimallIconButton.ghost(
                                      size: 28,
                                      icon: const Icon(Icons.delete, size: 14),
                                      onPressed: () => _deleteService(service),
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
