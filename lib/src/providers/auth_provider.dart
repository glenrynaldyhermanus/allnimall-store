import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/data/objects/user.dart';
import 'package:allnimall_store/src/data/usecases/sign_in_usecase.dart';
import 'package:allnimall_store/src/data/usecases/sign_out_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_current_user_usecase.dart';
import 'package:allnimall_store/src/data/usecases/is_authenticated_usecase.dart';
import 'package:allnimall_store/src/data/usecases/authenticate_with_token_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_user_business_store_usecase.dart';
import 'package:allnimall_store/src/data/repositories/auth_repository_impl.dart';
import 'package:allnimall_store/src/core/services/business_store_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

// Auth State
abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;

  const Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}

// Repository Providers
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final supabaseClient = ref.read(supabaseClientProvider);
  return AuthRepositoryImpl(supabaseClient);
});

final businessStoreServiceProvider = Provider<BusinessStoreService>((ref) {
  final supabaseClient = ref.read(supabaseClientProvider);
  return BusinessStoreService(supabaseClient);
});

// UseCase Providers
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SignInUseCase(authRepository);
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return SignOutUseCase(authRepository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUserUseCase(authRepository);
});

final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return IsAuthenticatedUseCase(authRepository);
});

final authenticateWithTokenUseCaseProvider =
    Provider<AuthenticateWithTokenUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthenticateWithTokenUseCase(authRepository);
});

final getUserBusinessStoreUseCaseProvider =
    Provider<GetUserBusinessStoreUseCase>((ref) {
  final businessStoreService = ref.read(businessStoreServiceProvider);
  return GetUserBusinessStoreUseCase(businessStoreService);
});

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthInitial());

  Future<void> signIn(String username, String password) async {
    debugPrint('🔐 Starting sign in process for username: $username');
    state = AuthLoading();

    try {
      final signInUseCase = ref.read(signInUseCaseProvider);
      final getUserBusinessStoreUseCase =
          ref.read(getUserBusinessStoreUseCaseProvider);

      debugPrint('👤 Calling sign in use case...');
      final user = await signInUseCase(username, password);

      if (user != null) {
        debugPrint('✅ Sign in successful for user: ${user.name}');
        // Get business and store data after successful login
        try {
          debugPrint('🏪 Loading business and store data...');
          await getUserBusinessStoreUseCase.execute();
          debugPrint('✅ Business and store data loaded successfully');
          state = Authenticated(user);
        } catch (businessError) {
          debugPrint('⚠️ Business data loading failed: $businessError');
          state = Authenticated(user);
        }
      } else {
        debugPrint('❌ Sign in failed: Invalid credentials');
        state = const AuthError(
            'Nama pengguna atau kata sandi salah. Silakan periksa kredensial Anda dan coba lagi.');
      }
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      String errorMessage = 'Login gagal. Silakan coba lagi.';

      // Provide more specific error messages based on the error
      if (e.toString().contains('User not found')) {
        errorMessage = 'Pengguna tidak ditemukan. Silakan periksa nama pengguna Anda.';
      } else if (e.toString().contains('Invalid password')) {
        errorMessage = 'Kata sandi salah. Silakan periksa kata sandi Anda.';
      } else if (e.toString().contains('Invalid credentials')) {
        errorMessage =
            'Kredensial salah. Silakan periksa nama pengguna dan kata sandi Anda.';
      } else if (e.toString().contains('inactive')) {
        errorMessage =
            'Akun Anda tidak aktif. Silakan hubungi administrator.';
      } else if (e.toString().contains('Network')) {
        errorMessage = 'Error jaringan. Silakan periksa koneksi internet Anda.';
      }

      state = AuthError(errorMessage);
    }
  }

  Future<void> signOut() async {
    state = AuthLoading();

    try {
      final signOutUseCase = ref.read(signOutUseCaseProvider);
      await signOutUseCase();
      state = Unauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> checkAuthStatus() async {
    state = AuthLoading();

    try {
      final isAuthenticatedUseCase = ref.read(isAuthenticatedUseCaseProvider);
      final getCurrentUserUseCase = ref.read(getCurrentUserUseCaseProvider);

      final isAuthenticated = await isAuthenticatedUseCase();
      if (isAuthenticated) {
        final user = await getCurrentUserUseCase();
        if (user != null) {
          state = Authenticated(user);
        } else {
          state = Unauthenticated();
        }
      } else {
        state = Unauthenticated();
      }
    } catch (e) {
      // Jika ada error, set ke Unauthenticated agar tidak stuck di loading
      debugPrint('Auth check error: $e');
      state = Unauthenticated();
    }
  }

  Future<void> authenticateWithToken(String token) async {
    state = AuthLoading();

    try {
      final authenticateWithTokenUseCase =
          ref.read(authenticateWithTokenUseCaseProvider);
      final user = await authenticateWithTokenUseCase.execute(token);
      if (user != null) {
        state = Authenticated(user);
      } else {
        state = const AuthError('Invalid token');
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
