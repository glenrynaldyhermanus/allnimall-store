import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';

class TaxesContent extends ConsumerWidget {
  const TaxesContent({super.key});

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
              Icons.receipt_long_outlined,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Pengaturan Pajak',
              style: _getSystemFont(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new tax rule
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Aturan Pajak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Tax Settings Form
        SizedBox(
          height: 600,
          child: Row(
            children: [
              // Left Panel - Tax Rules
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aturan Pajak',
                      style: _getSystemFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 400, // Fixed height for tax rules list
                      child: ListView.builder(
                        itemCount: 4, // Sample data
                        itemBuilder: (context, index) {
                          final taxRules = [
                            {
                              'name': 'PPN 11%',
                              'rate': 11.0,
                              'type': 'percentage',
                              'status': 'active'
                            },
                            {
                              'name': 'PPh 21',
                              'rate': 5.0,
                              'type': 'percentage',
                              'status': 'active'
                            },
                            {
                              'name': 'Pajak Rokok',
                              'rate': 15.0,
                              'type': 'percentage',
                              'status': 'active'
                            },
                            {
                              'name': 'Pajak Minuman',
                              'rate': 10.0,
                              'type': 'percentage',
                              'status': 'inactive'
                            },
                          ];

                          final rule = taxRules[index];
                          final isActive = rule['status'] == 'active';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.blue.withValues(alpha: 0.1)
                                            : Colors.grey
                                                .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.receipt,
                                        color: isActive
                                            ? Colors.blue
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            rule['name'] as String,
                                            style: _getSystemFont(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${rule['rate']}%',
                                            style: _getSystemFont(
                                              fontSize: 12,
                                              color: AppColors.secondaryText,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: isActive,
                                      onChanged: (value) {
                                        // TODO: Toggle tax rule status
                                      },
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // TODO: Edit tax rule
                                      },
                                      icon: const Icon(Icons.edit),
                                      tooltip: 'Edit Aturan Pajak',
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
                ),
              ),
              const SizedBox(width: 24),
              // Right Panel - Tax Configuration
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Konfigurasi Pajak',
                      style: _getSystemFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pengaturan Umum',
                              style: _getSystemFont(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pajak Otomatis',
                                        style: _getSystemFont(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Switch(
                                        value: true,
                                        onChanged: (value) {
                                          // TODO: Toggle auto tax
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Tampilkan Pajak',
                                        style: _getSystemFont(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Switch(
                                        value: true,
                                        onChanged: (value) {
                                          // TODO: Toggle tax display
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Pembulatan Pajak',
                              style: _getSystemFont(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButton<String>(
                              value: 'round',
                              isExpanded: true,
                              items: const [
                                DropdownMenuItem(
                                    value: 'round',
                                    child: Text('Pembulatan ke atas')),
                                DropdownMenuItem(
                                    value: 'floor',
                                    child: Text('Pembulatan ke bawah')),
                                DropdownMenuItem(
                                    value: 'nearest',
                                    child: Text('Pembulatan terdekat')),
                              ],
                              onChanged: (value) {
                                // TODO: Change tax rounding
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Laporan Pajak',
                              style: _getSystemFont(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Generate tax report
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Unduh Laporan Pajak'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
