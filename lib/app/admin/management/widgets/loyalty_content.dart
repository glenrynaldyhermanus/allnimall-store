import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class LoyaltyContent extends ConsumerStatefulWidget {
  const LoyaltyContent({super.key});

  @override
  ConsumerState<LoyaltyContent> createState() => _LoyaltyContentState();
}

class _LoyaltyContentState extends ConsumerState<LoyaltyContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadLoyaltyPrograms();
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
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text('Error loading loyalty programs',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(state.message,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.secondaryText)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadLoyaltyPrograms(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state is LoyaltyProgramsLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard_outlined,
                  size: 24, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text('Program Loyalitas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Tambah Program'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: state.programs.length,
              itemBuilder: (context, index) {
                final program = state.programs[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.card_giftcard,
                        color: AppColors.primary),
                    title: Text(program['name'] ?? 'Program ${index + 1}'),
                    subtitle: Text(program['description'] ?? '-'),
                    trailing: Text(
                        program['is_active'] == true ? 'Aktif' : 'Tidak Aktif'),
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
