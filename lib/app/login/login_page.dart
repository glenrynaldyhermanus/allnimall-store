import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:allnimall_store/src/core/utils/responsive.dart';
import 'package:allnimall_store/app/login/widgets/product_panel.dart';
import 'package:allnimall_store/app/login/widgets/login_panel.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Row(
        children: [
          // Left Panel - Promo & Products (3/4 width on desktop, hidden on mobile)
          if (!Responsive.isMobile(context))
            const Expanded(
              flex: 3,
              child: ProductPanel(),
            ),

          // Right Panel - Login Form (1/4 width on desktop, full width on mobile)
          const Expanded(
            child: LoginPanel(),
          ),
        ],
      ),
    );
  }
}
