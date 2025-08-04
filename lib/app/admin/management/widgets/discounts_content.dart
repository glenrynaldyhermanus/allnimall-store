import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class DiscountsContent extends ConsumerStatefulWidget {
  const DiscountsContent({super.key});

  @override
  ConsumerState<DiscountsContent> createState() => _DiscountsContentState();
}

class _DiscountsContentState extends ConsumerState<DiscountsContent> {
  @override
  void initState() {
    super.initState();
    // Auto-load discounts when widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadDiscounts();
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
              'Error loading discounts',
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
                  ref.read(managementProvider.notifier).loadDiscounts(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is DiscountsLoaded) {
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
              const Text(
                'Kelola Diskon',
                style: TextStyle(
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
          // Discounts content here
          Expanded(
            child: ListView.builder(
              itemCount: state.discounts.length,
              itemBuilder: (context, index) {
                final discount = state.discounts[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(
                        discount['name']?.substring(0, 1).toUpperCase() ?? 'D',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(discount['name'] ?? 'Diskon ${index + 1}'),
                    subtitle: Text('${discount['percentage'] ?? 10}% off'),
                    trailing: Text(discount['is_active'] == true
                        ? 'Aktif'
                        : 'Tidak Aktif'),
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
