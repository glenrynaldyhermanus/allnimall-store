import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:allnimall_store/src/core/theme/app_theme.dart';
// import 'package:allnimall_store/src/providers/management_provider.dart';

class PetsContent extends ConsumerStatefulWidget {
  const PetsContent({super.key});

  @override
  ConsumerState<PetsContent> createState() => _PetsContentState();
}

class _PetsContentState extends ConsumerState<PetsContent> {
  @override
  void initState() {
    super.initState();
    // TODO: Panggil ref.read(managementProvider.notifier).loadPets(); jika sudah ada
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Ganti dengan state management jika sudah ada
    return const Center(
      child: Text('Fitur hewan peliharaan belum tersedia.'),
    );
  }
}
