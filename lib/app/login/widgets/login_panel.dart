import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/core/utils/responsive.dart';
import 'package:allnimall_store/src/providers/auth_provider.dart';
import 'package:allnimall_store/src/widgets/ui/feedback/allnimall_toast.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class LoginPanel extends ConsumerStatefulWidget {
  const LoginPanel({super.key});

  @override
  ConsumerState<LoginPanel> createState() => _LoginPanelState();
}

class _LoginPanelState extends ConsumerState<LoginPanel>
    with TickerProviderStateMixin {
  // Form keys
  final _usernameKey = const TextFieldKey('username');
  final _passwordKey = const TextFieldKey('password');

  // Text controllers for direct access
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _fadeController;

  // Animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<Offset> _formSlideAnimation;
  late Animation<double> _fadeAnimation;

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

    // Start animations
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      debugPrint(
          '🔄 Auth state changed: ${previous.runtimeType} -> ${next.runtimeType}');

      if (next is Authenticated) {
        debugPrint('✅ User authenticated, navigating to POS...');
        setState(() {
          _isLoading = false;
        });

        // Redirect directly without success toast since user will be redirected
        GoRouter.of(context).go('/pos');
      } else if (next is AuthError) {
        debugPrint('❌ Auth error: ${next.message}');
        setState(() {
          _isLoading = false;
        });

        // Show toast for error
        AllnimallToast.error(
          context: context,
          title: 'Login Gagal',
          content: next.message,
        );
      } else if (next is AuthLoading) {
        debugPrint('⏳ Auth loading...');
        setState(() {
          _isLoading = true;
        });
      }
    });

    return Container(
      constraints: BoxConstraints(
        maxWidth: Responsive.isMobile(context) ? double.infinity : 400,
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
                maxWidth: Responsive.isMobile(context) ? double.infinity : 400,
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Username field with AllnimallTextInput
                                AllnimallFormField(
                                  fieldKey: _usernameKey,
                                  label: 'Username',
                                  placeholder: 'Username',
                                  controller: _usernameController,
                                  showErrors: const {
                                    FormValidationMode.changed,
                                    FormValidationMode.submitted
                                  },
                                  onSubmitted: (value) {
                                    // Focus to password field when Enter is pressed
                                    FocusScope.of(context).nextFocus();
                                  },
                                ),

                                // Password field with AllnimallTextInput
                                AllnimallFormField(
                                  fieldKey: _passwordKey,
                                  label: 'Password',
                                  placeholder: 'Password',
                                  obscureText: !_isPasswordVisible,
                                  controller: _passwordController,
                                  showErrors: const {
                                    FormValidationMode.changed,
                                    FormValidationMode.submitted
                                  },
                                  onSubmitted: (value) {
                                    // Trigger login directly when Enter is pressed
                                    if (!_isLoading &&
                                        authState is! AuthLoading) {
                                      // Get values directly from controllers
                                      final username =
                                          _usernameController.text.trim();
                                      final password = _passwordController.text;

                                      if (username.isNotEmpty &&
                                          password.isNotEmpty) {
                                        debugPrint(
                                            '🚀 Starting login process from Enter key...');
                                        ref
                                            .read(authProvider.notifier)
                                            .signIn(username, password);
                                      } else {
                                        // Show toast for empty fields
                                        if (context.mounted) {
                                          AllnimallToast.warning(
                                            context: context,
                                            title: 'Data Tidak Lengkap',
                                            content:
                                                'Masukkan username dan password',
                                          );
                                        }
                                      }
                                    }
                                  },
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
                                              ? LucideIcons.eyeOff
                                              : LucideIcons.eye,
                                        ),
                                        variance: ButtonVariance.ghost,
                                      ),
                                    ),
                                  ],
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
                                      ? () async {
                                          try {
                                            final formValues =
                                                await context.submitForm();
                                            debugPrint(
                                                '✅ Form submitted successfully: $formValues');

                                            // Extract username and password from form values
                                            final username =
                                                _usernameKey[formValues.values];
                                            final password =
                                                _passwordKey[formValues.values];

                                            if (username != null &&
                                                password != null) {
                                              // Call auth provider to sign in
                                              ref
                                                  .read(authProvider.notifier)
                                                  .signIn(username, password);
                                            } else {
                                              // Show toast for empty fields
                                              if (context.mounted) {
                                                AllnimallToast.warning(
                                                  context: context,
                                                  title: 'Data Tidak Lengkap',
                                                  content:
                                                      'Masukkan username dan password',
                                                );
                                              }
                                            }
                                          } catch (e) {
                                            debugPrint(
                                                '❌ Form validation failed: $e');
                                            // Show toast for form validation error
                                            if (context.mounted) {
                                              AllnimallToast.error(
                                                context: context,
                                                title: 'Validasi Form Gagal',
                                                content:
                                                    'Silakan periksa kembali data yang Anda masukkan.',
                                              );
                                            }
                                          }
                                        }
                                      : null,
                                  isLoading:
                                      _isLoading || authState is AuthLoading,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Masuk',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          '↵',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
