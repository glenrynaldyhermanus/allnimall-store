import 'package:flutter/material.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Management'),
        ),
        body: const Center(
          child: Text('Management Page - Protected by AuthGuard'),
        ),
      ),
    );
  }
}
