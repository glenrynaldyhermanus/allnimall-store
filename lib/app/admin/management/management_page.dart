import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthGuard(
      child: Scaffold(
        headers: [
          AllnimallAppBar(
            title: 'Management',
            subtitle: 'Kelola Produk dan Kategori',
          ),
        ],
        child: Center(
          child: Text('Management Page - Protected by AuthGuard'),
        ),
      ),
    );
  }
}
