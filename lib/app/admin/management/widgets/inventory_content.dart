import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class InventoryContent extends ConsumerStatefulWidget {
  const InventoryContent({super.key});

  @override
  ConsumerState<InventoryContent> createState() => _InventoryContentState();
}

class _InventoryContentState extends ConsumerState<InventoryContent> {
  @override
  void initState() {
    super.initState();
    // Auto-load inventory when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadInventory();
    });
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
              'Error loading inventory',
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
              const Text(
                'Kelola Inventory',
                style: TextStyle(
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
                label: const Text('Tambah Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Inventory content here
          Expanded(
            child: ListView.builder(
              itemCount: state.inventory.length,
              itemBuilder: (context, index) {
                final product = state.inventory[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        product.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(product.name),
                    subtitle: Text('Stok: ${product.stock}'),
                    trailing: Text('Rp ${product.price}'),
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
