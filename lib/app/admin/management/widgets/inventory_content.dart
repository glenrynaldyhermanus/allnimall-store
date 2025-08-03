import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class InventoryContent extends ConsumerWidget {
  const InventoryContent({super.key});

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
            Text(
              'Error loading inventory',
              style: _getSystemFont(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: _getSystemFont(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadInventory(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is InventoryLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.warehouse_outlined,
                size: 24,
                color: AppColors.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'Kelola Inventory',
                style: _getSystemFont(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Add new inventory item
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah Stok'),
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
                        hintText: 'Cari produk...',
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
                          value: 'all', child: Text('Semua Kategori')),
                      DropdownMenuItem(
                          value: 'low', child: Text('Stok Menipis')),
                      DropdownMenuItem(value: 'out', child: Text('Habis')),
                    ],
                    onChanged: (value) {
                      // TODO: Filter inventory
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Inventory Grid
          SizedBox(
            height: 600,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width < 1200 ? 2 : 3,
                childAspectRatio: 3.0,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.inventory.length,
              itemBuilder: (context, index) {
                final item = state.inventory[index];
                final stock = item.stock;
                final minStock = item.minStock;
                final isLowStock = stock <= minStock;
                final isOutOfStock = stock == 0;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                color: AppColors.primary,
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
                                    item.name,
                                    style: _getSystemFont(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'SKU: ${item.id}',
                                    style: _getSystemFont(
                                      fontSize: 12,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isOutOfStock
                                    ? Colors.red.withValues(alpha: 0.1)
                                    : isLowStock
                                        ? Colors.orange
                                            .withValues(alpha: 0.1)
                                        : Colors.green
                                            .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isOutOfStock
                                    ? 'Habis'
                                    : isLowStock
                                        ? 'Menipis'
                                        : 'Tersedia',
                                style: _getSystemFont(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isOutOfStock
                                      ? Colors.red
                                      : isLowStock
                                          ? Colors.orange
                                          : Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Stok',
                                    style: _getSystemFont(
                                      fontSize: 12,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    stock.toString(),
                                    style: _getSystemFont(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isOutOfStock
                                          ? Colors.red
                                          : isLowStock
                                              ? Colors.orange
                                              : AppColors.primary,
                                    ),
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
                                    'Min. Stok',
                                    style: _getSystemFont(
                                      fontSize: 12,
                                      color: AppColors.secondaryText,
                                    ),
                                  ),
                                  Text(
                                    minStock.toString(),
                                    style: _getSystemFont(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
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
                                  // TODO: Edit inventory
                                },
                                child: const Text('Edit'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isOutOfStock
                                    ? () {
                                        // TODO: Restock
                                      }
                                    : null,
                                child: const Text('Restock'),
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

    return const Center(child: CircularProgressIndicator());
  }
} 