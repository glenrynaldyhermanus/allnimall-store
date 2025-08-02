import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/providers/auth_provider.dart';
import 'package:allnimall_store/src/core/routes/app_router.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final String? requiredRole;
  final String? requiredPermission;

  const AuthGuard({
    super.key,
    required this.child,
    this.requiredRole,
    this.requiredPermission,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState is AuthLoading) {
      return const AuthGuardLoading();
    }

    if (authState is AuthError) {
      // Error autentikasi, redirect ke login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRouter.loginRoute);
      });
      return const AuthGuardLoading();
    }

    if (authState is Unauthenticated || authState is AuthInitial) {
      // User belum login, redirect ke login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(AppRouter.loginRoute);
      });
      return const AuthGuardLoading();
    }

    if (authState is Authenticated) {
      // User sudah login, cek role/permission jika diperlukan
      if (requiredRole != null || requiredPermission != null) {
        return _checkAccess(context, ref, authState.user);
      }

      // User sudah login dan tidak ada requirement khusus
      return child;
    }

    // Default case, redirect ke login
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRouter.loginRoute);
    });
    return const AuthGuardLoading();
  }

  Widget _checkAccess(BuildContext context, WidgetRef ref, dynamic user) {
    // TODO: Implement role dan permission checking
    // Untuk sekarang, kita asumsikan semua user yang login punya akses
    return child;
  }
}

class AuthGuardLoading extends StatelessWidget {
  const AuthGuardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const Gap(16),
            const Text('Memverifikasi akses...').muted(),
          ],
        ),
      ),
    );
  }
}

// Extension untuk memudahkan penggunaan AuthGuard
extension AuthGuardExtension on Widget {
  Widget withAuthGuard({
    String? requiredRole,
    String? requiredPermission,
  }) {
    return AuthGuard(
      requiredRole: requiredRole,
      requiredPermission: requiredPermission,
      child: this,
    );
  }
}
