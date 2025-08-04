import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:allnimall_store/src/core/theme/app_theme.dart';
// import 'package:allnimall_store/src/providers/management_provider.dart';

class TaxesContent extends ConsumerStatefulWidget {
  const TaxesContent({super.key});

  @override
  ConsumerState<TaxesContent> createState() => _TaxesContentState();
}

class _TaxesContentState extends ConsumerState<TaxesContent> {
  @override
  void initState() {
    super.initState();
    // TODO: Panggil ref.read(managementProvider.notifier).loadTaxes(); jika sudah ada
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Ganti dengan state management jika sudah ada
    return const Center(
      child: Text('Fitur pajak belum tersedia.'),
    );
  }
}
