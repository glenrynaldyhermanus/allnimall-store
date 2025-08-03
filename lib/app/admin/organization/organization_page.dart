import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';

class OrganizationPage extends StatelessWidget {
  const OrganizationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthGuard(
      child: Scaffold(
        headers: [
          AllnimallAppBar(
            title: 'Organization',
            subtitle: 'Kelola Bisnis dan Toko',
          ),
        ],
        child: Center(
          child: Text('Organization Page - Protected by AuthGuard'),
        ),
      ),
    );
  }
}
