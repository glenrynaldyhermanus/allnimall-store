import 'package:flutter/material.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reports'),
        ),
        body: const Center(
          child: Text('Reports Page - Protected by AuthGuard'),
        ),
      ),
    );
  }
}
