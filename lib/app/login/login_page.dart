import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:allnimall_store/src/providers/auth_provider.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/widgets/allnimall_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with TickerProviderStateMixin {
  // Form keys
  final _usernameKey = const TextFieldKey('username');
  final _passwordKey = const TextFieldKey('password');

  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _fadeController;
  late AnimationController _leftPanelController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _formSlideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _leftPanelSlideAnimation;

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _leftPanelController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Setup animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    _formSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _leftPanelSlideAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _leftPanelController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    _leftPanelController.forward();

    await Future.delayed(const Duration(milliseconds: 500));
    _formController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _fadeController.dispose();
    _leftPanelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      debugPrint(
          '🔄 Auth state changed: ${previous.runtimeType} -> ${next.runtimeType}');

      if (next is Authenticated) {
        debugPrint('✅ User authenticated, navigating to POS...');
        setState(() {
          _isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Selamat datang kembali, ${next.user.name}!'),
        //     backgroundColor: AppColors.success,
        //     duration: const Duration(seconds: 2),
        //   ),
        // );
        GoRouter.of(context).go('/pos');
      } else if (next is AuthError) {
        debugPrint('❌ Auth error: ${next.message}');
        setState(() {
          _isLoading = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(next.message),
        //     backgroundColor: AppColors.error,
        //     duration: const Duration(seconds: 4),
        //   ),
        // );
      } else if (next is AuthLoading) {
        debugPrint('⏳ Auth loading...');
        setState(() {
          _isLoading = true;
        });
      }
    });

    return Scaffold(
      child: Row(
        children: [
          // Left Panel - Promo & Products (3/4 width on desktop, hidden on mobile)
          if (!isMobile)
            Expanded(
              flex: 3,
              child: AnimatedBuilder(
                animation: _leftPanelController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_leftPanelSlideAnimation.value * 100, 0),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryLight,
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Logo Section

                              const Gap(48),

                              // Welcome Text
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selamat Datang',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                    const Gap(8),
                                    const Text(
                                      'Allnimall Store',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const Gap(16),
                                    Text(
                                      'Aplikasi Kasir yang Mengutamakan Hewan Peliharaan',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Colors.white.withValues(alpha: 0.9),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // Features Section
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Fitur Utama',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Gap(24),
                                    _buildFeatureItem(
                                      icon: Icons.pets,
                                      title: 'Manajemen Hewan Peliharaan',
                                      description:
                                          'Kelola data hewan peliharaan milik pelanggan dengan mudah',
                                    ),
                                    const Gap(16),
                                    _buildFeatureItem(
                                      icon: Icons.schedule,
                                      title: 'Jadwal & Appointment',
                                      description:
                                          'Buat pengaturan jadwal grooming dan perawatan hewan peliharaan',
                                    ),
                                    const Gap(16),
                                    _buildFeatureItem(
                                      icon: Icons.inventory,
                                      title: 'Manajemen Inventori',
                                      description:
                                          'Kelola stok produk dan inventori produk',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

          // Right Panel - Login Form (1/4 width on desktop, full width on mobile)
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile ? double.infinity : 400,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isMobile ? double.infinity : 400,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Logo Section (only show on desktop)
                          AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _logoScaleAnimation.value,
                                child: Transform.rotate(
                                  angle: _logoRotationAnimation.value,
                                  child: SizedBox(
                                    width: 240,
                                    child: Image.asset(
                                      'assets/images/ic_allnimall_logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          const Gap(40),

                          // Title Section (only on mobile)

                          SlideTransition(
                            position: _formSlideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: const Column(
                                children: [
                                  Text(
                                    'Selamat Datang Kembali',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryText,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  Gap(8),
                                  Text(
                                    'Masuk ke akun Allnimall Anda',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.secondaryText,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Gap(32),

                          // Login Form
                          SlideTransition(
                            position: _formSlideAnimation,
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Form(
                                onSubmit: (context, values) {
                                  // Get the values individually
                                  String? username = _usernameKey[values];
                                  String? password = _passwordKey[values];

                                  if (username == null || password == null) {
                                    debugPrint('❌ Form validation failed');
                                    return;
                                  }

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  debugPrint('🚀 Starting login process...');
                                  ref
                                      .read(authProvider.notifier)
                                      .signIn(username.trim(), password);
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        FormField(
                                          key: _usernameKey,
                                          label: const Text('Username'),
                                          showErrors: const {
                                            FormValidationMode.changed,
                                            FormValidationMode.submitted
                                          },
                                          child: const TextField(
                                            placeholder: Text('Username'),
                                          ).constrained(height: 44),
                                        ),
                                        FormField(
                                          key: _passwordKey,
                                          label: const Text('Password'),
                                          showErrors: const {
                                            FormValidationMode.changed,
                                            FormValidationMode.submitted
                                          },
                                          child: TextField(
                                            placeholder: const Text('Password'),
                                            obscureText: !_isPasswordVisible,
                                            features: [
                                              InputFeature.trailing(
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isPasswordVisible =
                                                          !_isPasswordVisible;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    _isPasswordVisible
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  ),
                                                  variance:
                                                      ButtonVariance.ghost,
                                                ),
                                              ),
                                            ],
                                          ).constrained(height: 44),
                                        ),
                                      ],
                                    ).gap(24),
                                    const Gap(24),
                                    FormErrorBuilder(
                                      builder: (context, errors, child) {
                                        return AllnimallButton(
                                          onPressed: errors.isEmpty &&
                                                  !_isLoading &&
                                                  authState is! AuthLoading
                                              ? () => context.submitForm()
                                              : null,
                                          isLoading: _isLoading ||
                                              authState is AuthLoading,
                                          child: const Text(
                                            'Masuk',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const Gap(32),

                          // Demo Credentials (only on mobile)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Gap(4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
