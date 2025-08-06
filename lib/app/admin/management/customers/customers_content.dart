import 'package:allnimall_store/app/admin/management/customers/widgets/customer_form_sheet.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/data/objects/customer.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_dialog.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/widgets/ui/table/allnimall_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class CustomersContent extends ConsumerStatefulWidget {
  const CustomersContent({super.key});

  @override
  ConsumerState<CustomersContent> createState() => _CustomersContentState();
}

class _CustomersContentState extends ConsumerState<CustomersContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadCustomers();
    });
  }

  Future<void> _editCustomer(Customer customer) async {
    openSheet(
      context: context,
      builder: (context) => CustomerFormSheet(customer: customer),
      position: OverlayPosition.right,
    );
  }

  Future<void> _deleteCustomer(Customer customer) async {
    await AllnimallDialog.show(
      context: context,
      title: 'Hapus Pelanggan',
      content:
          'Apakah Anda yakin ingin menghapus pelanggan "${customer.name}"? Tindakan ini tidak dapat dibatalkan.',
      confirmText: 'Hapus',
      cancelText: 'Batal',
      isDestructive: true,
      onConfirm: () async {
        try {
          await SupabaseService.softDeleteCustomer(customer.id);

          // Reload customers after deletion
          ref.read(managementProvider.notifier).loadCustomers();

          // Show success toast
          if (mounted) {
            showToast(
              context: context,
              builder: (context, overlay) => SurfaceCard(
                child: Basic(
                  title: const Text('Berhasil'),
                  content: const Text('Pelanggan berhasil dihapus'),
                  trailing: AllnimallButton.primary(
                    onPressed: () => overlay.close(),
                    label: 'Tutup',
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
                  content: Text('Gagal menghapus pelanggan: ${e.toString()}'),
                  trailing: AllnimallButton.primary(
                    onPressed: () => overlay.close(),
                    label: 'Tutup',
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
            const Text('Error loading customers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(state.message,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.secondaryText)),
            const SizedBox(height: 24),
            AllnimallButton.primary(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadCustomers(),
              label: 'Coba Lagi',
            ),
          ],
        ),
      );
    }
    if (state is CustomersLoaded) {
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
                  const Icon(Icons.people_outline,
                      size: 24, color: AppColors.primary),
                  const SizedBox(width: 12),
                  const Text('Kelola Pelanggan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  AllnimallButton.primary(
                    onPressed: () {
                      openSheet(
                        context: context,
                        builder: (context) => const CustomerFormSheet(),
                        position: OverlayPosition.right,
                      );
                    },
                    label: 'Tambah Pelanggan',
                  ),
                ],
              ),
            ),

            // Content section with fixed height
            Expanded(
              child: state.customers.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline,
                              size: 64, color: AppColors.secondaryText),
                          SizedBox(height: 16),
                          Text('Belum ada pelanggan',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondaryText)),
                          SizedBox(height: 8),
                          Text('Tambahkan pelanggan pertama Anda',
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
                          child: Text('Pelanggan'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Email'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Telepon'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Alamat'),
                        ).build(context),
                        const AllnimallTableCell(
                          isHeader: true,
                          child: Text('Total Transaksi'),
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
                      rows: state.customers.map((customer) {
                        final customerData = customer;
                        return TableRow(
                          cells: [
                            // Customer info
                            AllnimallTableCell(
                              expanded: false,
                              width: 350, // Lebar tetap untuk kolom pelanggan
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
                                        (customerData['name'] ?? 'P')
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
                                      customerData['name'] ?? 'Pelanggan',
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
                            // Email
                            AllnimallTableCell(
                              expanded: false,
                              width: 200,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                customerData['email'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ).build(context),
                            // Phone
                            AllnimallTableCell(
                              expanded: false,
                              width: 150,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                customerData['phone'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ).build(context),
                            // Address
                            AllnimallTableCell(
                              expanded: false,
                              width: 250,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                customerData['address'] ?? '-',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.secondaryText,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ).build(context),
                            // Total Transactions
                            AllnimallTableCell(
                              expanded: false,
                              width: 140,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              child: Text(
                                '${customerData['total_transactions'] ?? 0}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary,
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
                                  color: (customerData['is_active'] ?? true)
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  (customerData['is_active'] ?? true)
                                      ? 'Aktif'
                                      : 'Nonaktif',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: (customerData['is_active'] ?? true)
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
                                      onPressed: () => _editCustomer(
                                          Customer.fromJson(customerData)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: AllnimallIconButton.ghost(
                                      size: 28,
                                      icon: const Icon(Icons.delete, size: 14),
                                      onPressed: () => _deleteCustomer(
                                          Customer.fromJson(customerData)),
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
