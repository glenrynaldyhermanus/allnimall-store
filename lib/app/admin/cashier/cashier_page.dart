import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/pos_product_widget.dart';
import 'widgets/pos_cart_panel.dart';

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  // Loading State
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const AuthGuard(
      child: Scaffold(
        child: Row(
          children: [
            // Sidebar
            Sidebar(),
            // Left side - Product grid
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Header
                  AllnimallAppBar(),
                  // Product Widget
                  Expanded(
                    child: PosProductWidget(),
                  ),
                ],
              ),
            ),
            // Right side - Cart
            Expanded(
              child: PosCartPanel(),
            ),
          ],
        ),
      ),
    );
  }
}
