import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/app/cashier/cashier_page.dart';
import 'package:allnimall_store/app/login/login_page.dart';
import 'package:allnimall_store/app/management/management_page.dart';
import 'package:allnimall_store/app/organization/organization_page.dart';
import 'package:allnimall_store/app/payment/payment_page.dart';
import 'package:allnimall_store/app/payment/success_page.dart';

import 'package:allnimall_store/app/reports/reports_page.dart';
import 'package:allnimall_store/src/providers/auth_provider.dart';

class AppRouter {
  static const String loginRoute = '/login';
  static const String posRoute = '/pos';
  static const String managementRoute = '/management';
  static const String organizationRoute = '/organization';
  static const String reportsRoute = '/reports';
  static const String paymentRoute = '/payment';
  static const String successRoute = '/success';

  // Helper method untuk fade transition
  static Page<void> _buildPageWithFadeTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Skip redirect for login page to avoid infinite loop
      if (state.matchedLocation == loginRoute) {
        return null;
      }

      // Get auth state from provider
      final container = ProviderScope.containerOf(context);
      final authState = container.read(authProvider);

      // If user is authenticated, allow access to all routes
      if (authState is Authenticated) {
        return null;
      }

      // If user is not authenticated, redirect to login
      if (authState is Unauthenticated || authState is AuthInitial) {
        return loginRoute;
      }

      // If auth is loading, stay on current page
      if (authState is AuthLoading) {
        return null;
      }

      // Default to login
      return loginRoute;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => posRoute,
      ),
      GoRoute(
        path: loginRoute,
        name: 'login',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const LoginPage(),
        ),
      ),
      GoRoute(
        path: posRoute,
        name: 'pos',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const CashierPage(),
        ),
      ),
      GoRoute(
        path: managementRoute,
        name: 'management',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const ManagementPage(),
        ),
      ),
      GoRoute(
        path: organizationRoute,
        name: 'organization',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const OrganizationPage(),
        ),
      ),
      GoRoute(
        path: reportsRoute,
        name: 'reports',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const ReportsPage(),
        ),
      ),
      GoRoute(
        path: paymentRoute,
        name: 'payment',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const PaymentPage(),
        ),
      ),
      GoRoute(
        path: successRoute,
        name: 'success',
        pageBuilder: (context, state) => _buildPageWithFadeTransition(
          context,
          state,
          const SuccessPage(),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(loginRoute),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    ),
  );
}
