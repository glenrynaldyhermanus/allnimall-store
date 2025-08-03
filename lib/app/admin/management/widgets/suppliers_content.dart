import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';

class SuppliersContent extends ConsumerWidget {
  const SuppliersContent({super.key});

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
              Icons.local_shipping_outlined,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Kelola Supplier',
              style: _getSystemFont(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new supplier
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Supplier'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Suppliers Grid
        SizedBox(
          height: 600,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 1200 ? 1 : 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 8, // Sample data
            itemBuilder: (context, index) {
              final suppliers = [
                {
                  'name': 'PT Sukses Makmur',
                  'contact': 'Budi Santoso',
                  'phone': '+62 812-1111-001',
                  'email': 'budi@suksesmakmur.com'
                },
                {
                  'name': 'CV Maju Jaya',
                  'contact': 'Siti Aminah',
                  'phone': '+62 812-1111-002',
                  'email': 'siti@majujaya.com'
                },
                {
                  'name': 'UD Berkah Abadi',
                  'contact': 'Ahmad Rizki',
                  'phone': '+62 812-1111-003',
                  'email': 'ahmad@berkahabadi.com'
                },
                {
                  'name': 'PT Sejahtera Bersama',
                  'contact': 'Dewi Sartika',
                  'phone': '+62 812-1111-004',
                  'email': 'dewi@sejahterabersama.com'
                },
                {
                  'name': 'CV Mandiri Jaya',
                  'contact': 'Rudi Hartono',
                  'phone': '+62 812-1111-005',
                  'email': 'rudi@mandirijaya.com'
                },
                {
                  'name': 'PT Indah Permai',
                  'contact': 'Nina Safitri',
                  'phone': '+62 812-1111-006',
                  'email': 'nina@indahpermai.com'
                },
                {
                  'name': 'UD Makmur Sejati',
                  'contact': 'Eko Prasetyo',
                  'phone': '+62 812-1111-007',
                  'email': 'eko@makmursejati.com'
                },
                {
                  'name': 'CV Sukses Mandiri',
                  'contact': 'Rina Marlina',
                  'phone': '+62 812-1111-008',
                  'email': 'rina@suksesmandiri.com'
                },
              ];

              final supplier = suppliers[index];

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.business,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supplier['name'] as String,
                                  style: _getSystemFont(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Kontak: ${supplier['contact']}',
                                  style: _getSystemFont(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              // TODO: Handle menu actions
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, size: 16),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 16),
                                    Text('Hapus'),
                                  ],
                                ),
                              ),
                            ],
                            child: const Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.phone,
                            size: 14,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              supplier['phone'] as String,
                              style: _getSystemFont(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.email,
                            size: 14,
                            color: AppColors.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              supplier['email'] as String,
                              style: _getSystemFont(
                                fontSize: 12,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // TODO: View supplier details
                              },
                              child: const Text('Detail'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Contact supplier
                              },
                              child: const Text('Kontak'),
                            ),
                          ),
                        ],
                      ),
                    ],
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
