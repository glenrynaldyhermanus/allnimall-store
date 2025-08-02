import 'package:flutter/material.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Organization'),
        ),
        body: const Center(
          child: Text('Organization Page - Protected by AuthGuard'),
        ),
      ),
    );
  }
}
