import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';

class CustomersContent extends ConsumerWidget {
  const CustomersContent({super.key});

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
              Icons.people_outline,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Kelola Pelanggan',
              style: _getSystemFont(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new customer
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Pelanggan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Search and Filter
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari pelanggan...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: 'all',
                  items: const [
                    DropdownMenuItem(
                        value: 'all', child: Text('Semua Status')),
                    DropdownMenuItem(value: 'active', child: Text('Aktif')),
                    DropdownMenuItem(
                        value: 'inactive', child: Text('Tidak Aktif')),
                  ],
                  onChanged: (value) {
                    // TODO: Filter customers
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Customers Table
        SizedBox(
          height: 600,
          child: Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Telepon')),
                  DataColumn(label: Text('Alamat')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Total Transaksi')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: List.generate(10, (index) {
                  final isActive = index % 3 != 0;
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  AppColors.primary.withValues(alpha: 0.1),
                              child: Text(
                                'P${index + 1}',
                                style: _getSystemFont(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('Pelanggan ${index + 1}'),
                          ],
                        ),
                      ),
                      DataCell(Text('pelanggan${index + 1}@email.com')),
                      DataCell(Text(
                          '+62 812-3456-${(index + 1).toString().padLeft(2, '0')}')),
                      DataCell(
                          Text('Jl. Contoh No. ${index + 1}, Jakarta')),
                      DataCell(
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
                              color: isActive ? Colors.green : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      DataCell(Text('${(index + 1) * 3}')),
                      DataCell(
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Edit customer
                              },
                              icon: const Icon(Icons.edit, size: 16),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: View customer details
                              },
                              icon: const Icon(Icons.visibility, size: 16),
                              tooltip: 'Lihat Detail',
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
} 