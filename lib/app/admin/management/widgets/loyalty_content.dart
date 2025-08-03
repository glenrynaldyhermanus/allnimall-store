import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';

class LoyaltyContent extends ConsumerWidget {
  const LoyaltyContent({super.key});

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
              Icons.card_giftcard_outlined,
              size: 24,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Text(
              'Program Loyalitas',
              style: _getSystemFont(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Add new loyalty program
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Program'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Loyalty Programs Grid
        SizedBox(
          height: 600,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 1200 ? 1 : 2,
              childAspectRatio: 1.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 6, // Sample data
            itemBuilder: (context, index) {
              final programs = [
                {
                  'name': 'Member Silver',
                  'points': 100,
                  'discount': 5,
                  'status': 'active',
                  'members': 45
                },
                {
                  'name': 'Member Gold',
                  'points': 500,
                  'discount': 10,
                  'status': 'active',
                  'members': 28
                },
                {
                  'name': 'Member Platinum',
                  'points': 1000,
                  'discount': 15,
                  'status': 'active',
                  'members': 12
                },
                {
                  'name': 'Member Diamond',
                  'points': 2000,
                  'discount': 20,
                  'status': 'active',
                  'members': 5
                },
                {
                  'name': 'Birthday Special',
                  'points': 0,
                  'discount': 25,
                  'status': 'active',
                  'members': 8
                },
                {
                  'name': 'New Member',
                  'points': 50,
                  'discount': 3,
                  'status': 'inactive',
                  'members': 0
                },
              ];

              final program = programs[index];
              final isActive = program['status'] == 'active';

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
                              color: isActive
                                  ? Colors.purple.withValues(alpha: 0.1)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: isActive ? Colors.purple : Colors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  program['name'] as String,
                                  style: _getSystemFont(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? Colors.green.withValues(alpha: 0.1)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isActive ? 'Aktif' : 'Tidak Aktif',
                                    style: _getSystemFont(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          isActive ? Colors.green : Colors.grey,
                                    ),
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
                                value: 'members',
                                child: Row(
                                  children: [
                                    Icon(Icons.people, size: 16),
                                    SizedBox(width: 8),
                                    Text('Lihat Member'),
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Min. Poin',
                                  style: _getSystemFont(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  '${program['points']}',
                                  style: _getSystemFont(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Diskon',
                                  style: _getSystemFont(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  '${program['discount']}%',
                                  style: _getSystemFont(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Member',
                                  style: _getSystemFont(
                                    fontSize: 12,
                                    color: AppColors.secondaryText,
                                  ),
                                ),
                                Text(
                                  '${program['members']}',
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
                                // TODO: View program details
                              },
                              child: const Text('Detail'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Manage members
                              },
                              child: const Text('Kelola'),
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
