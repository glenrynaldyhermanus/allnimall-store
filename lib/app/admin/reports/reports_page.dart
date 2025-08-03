import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthGuard(
      child: Scaffold(
        headers: [
          AllnimallAppBar(
            title: 'Reports',
            subtitle: 'Laporan dan Analisis',
          ),
        ],
        child: Center(
          child: Text('Reports Page - Protected by AuthGuard'),
        ),
      ),
    );
  }
}
