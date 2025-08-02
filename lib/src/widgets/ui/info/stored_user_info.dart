import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/providers/auth_provider.dart';

class StoredUserInfo extends ConsumerWidget {
  const StoredUserInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi User yang Tersimpan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, dynamic>?>(
              future: ref.read(authProvider.notifier).getStoredUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final data = snapshot.data;
                if (data == null) {
                  return const Text('Tidak ada data user yang tersimpan');
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection('User Data', data['user']),
                    const SizedBox(height: 16),
                    _buildInfoSection('Business Data', data['business']),
                    const SizedBox(height: 16),
                    _buildInfoSection('Store Data', data['store']),
                    const SizedBox(height: 16),
                    _buildInfoSection('Role Data', data['role']),
                    const SizedBox(height: 16),
                    _buildInfoSection('Merchant Data', data['merchant']),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, dynamic data) {
    if (data == null) {
      return Text('$title: Tidak tersedia');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            data.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
