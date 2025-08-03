import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';

class DiscountsContent extends ConsumerWidget {
  const DiscountsContent({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            const Icon(
              Icons.local_offer_outlined,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Kelola Diskon & Promo',
              style: _getSystemFont(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new discount
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Diskon'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Discounts List
        SizedBox(
          height: 600,
          child: ListView.builder(
            itemCount: 6, // Sample data
            itemBuilder: (context, index) {
              final discounts = [
                {
                  'name': 'Diskon 10% Semua Produk',
                  'type': 'percentage',
                  'value': 10,
                  'status': 'active',
                  'expires': '2024-12-31'
                },
                {
                  'name': 'Potongan Rp 5.000',
                  'type': 'fixed',
                  'value': 5000,
                  'status': 'active',
                  'expires': '2024-11-30'
                },
                {
                  'name': 'Buy 1 Get 1 Free',
                  'type': 'bogo',
                  'value': 0,
                  'status': 'inactive',
                  'expires': '2024-10-15'
                },
                {
                  'name': 'Diskon 15% Minuman',
                  'type': 'percentage',
                  'value': 15,
                  'status': 'active',
                  'expires': '2024-12-15'
                },
                {
                  'name': 'Potongan Rp 10.000 Min. Belanja Rp 100.000',
                  'type': 'fixed',
                  'value': 10000,
                  'status': 'active',
                  'expires': '2024-11-20'
                },
                {
                  'name': 'Diskon 20% Rokok',
                  'type': 'percentage',
                  'value': 20,
                  'status': 'inactive',
                  'expires': '2024-09-30'
                },
              ];

              final discount = discounts[index];
              final isActive = discount['status'] == 'active';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_offer,
                            color: isActive ? Colors.green : Colors.grey,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                discount['name'] as String,
                                style: _getSystemFont(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      discount['type'] == 'percentage'
                                          ? '${discount['value']}%'
                                          : discount['type'] == 'fixed'
                                              ? 'Rp ${discount['value']}'
                                              : 'BOGO',
                                      style: _getSystemFont(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.green.withValues(alpha: 0.1)
                                          : Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      isActive ? 'Aktif' : 'Tidak Aktif',
                                      style: _getSystemFont(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isActive
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Berlaku sampai: ${discount['expires']}',
                                style: _getSystemFont(
                                  fontSize: 12,
                                  color: AppColors.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Edit discount
                              },
                              icon: const Icon(Icons.edit),
                              tooltip: 'Edit Diskon',
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Toggle discount status
                              },
                              icon: Icon(
                                isActive ? Icons.pause : Icons.play_arrow,
                              ),
                              tooltip: isActive ? 'Nonaktifkan' : 'Aktifkan',
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Delete discount
                              },
                              icon: const Icon(Icons.delete),
                              tooltip: 'Hapus Diskon',
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
