import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';

class ExpensesContent extends ConsumerStatefulWidget {
  const ExpensesContent({super.key});

  @override
  ConsumerState<ExpensesContent> createState() => _ExpensesContentState();
}

class _ExpensesContentState extends ConsumerState<ExpensesContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managementProvider.notifier).loadExpenses();
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
            const Text('Error loading expenses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(state.message,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.secondaryText)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  ref.read(managementProvider.notifier).loadExpenses(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (state is ExpensesLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.money_off_outlined,
                  size: 24, color: AppColors.primary),
              const SizedBox(width: 12),
              const Text('Kelola Biaya',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Tambah Biaya'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              itemCount: state.expenses.length,
              itemBuilder: (context, index) {
                final expense = state.expenses[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.attach_money,
                        color: AppColors.primary),
                    title: Text(expense['name'] ?? 'Biaya ${index + 1}'),
                    subtitle: Text('Rp ${expense['amount'] ?? 0}'),
                    trailing: Text(
                        expense['is_paid'] == true ? 'Lunas' : 'Belum Lunas'),
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
