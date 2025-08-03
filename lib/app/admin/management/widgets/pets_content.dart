import 'package:flutter/material.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';

class PetsContent extends StatelessWidget {
  const PetsContent({super.key});

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
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.pets,
                  size: 24,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Kelola Hewan Peliharaan',
                  style: _getSystemFont(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Add new pet
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Hewan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Fitur ini akan segera hadir untuk mengelola data hewan peliharaan pelanggan.',
              style: _getSystemFont(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 