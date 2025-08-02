import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'src/core/config/app_config.dart';
import 'src/core/routes/app_router.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/services/app_initialization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set URL strategy untuk web (no hash routing)
  if (kIsWeb) {
    // Use path URL strategy instead of hash
    // This will make URLs like /payment instead of /#/payment
    setPathUrlStrategy();
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );

  // Initialize app dan handle token jika ada
  await AppInitializationService.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      title: 'Allnimall Store',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        colorScheme: ColorSchemes.lightViolet().copyWith(
            primary: AppColors.primary, secondary: AppColors.secondary),
        radius: 0.5,
      ),
      builder: (context, child) {
        // Force landscape orientation for desktop/tablet
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);

        return child!;
      },
    );
  }
}
