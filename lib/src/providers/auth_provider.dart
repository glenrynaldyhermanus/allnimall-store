import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/data/objects/user.dart';
import 'package:allnimall_store/src/data/usecases/sign_in_usecase.dart';
import 'package:allnimall_store/src/data/usecases/sign_out_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_current_user_usecase.dart';
import 'package:allnimall_store/src/data/usecases/is_authenticated_usecase.dart';
import 'package:allnimall_store/src/data/usecases/authenticate_with_token_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_user_business_store_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_stored_user_data_usecase.dart';
import 'package:allnimall_store/src/data/repositories/auth_repository_impl.dart';
import 'package:allnimall_store/src/core/services/business_store_service.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
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

final getStoredUserDataUseCaseProvider =
    Provider<GetStoredUserDataUseCase>((ref) {
  return GetStoredUserDataUseCase();
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

        // Save user data to shared preferences
        try {
          debugPrint('💾 Saving user data to shared preferences...');
          await LocalStorageService.saveUserData(user.toJson());
          debugPrint('✅ User data saved successfully');
        } catch (userSaveError) {
          debugPrint('⚠️ Failed to save user data: $userSaveError');
        }

        // Get business and store data after successful login
        try {
          debugPrint('🏪 Loading business and store data...');
          final businessStoreData = await getUserBusinessStoreUseCase.execute();
          debugPrint('✅ Business and store data loaded successfully');

          final businessData = businessStoreData['business'];
          final storeData = businessStoreData['store'];
          final roleData = businessStoreData['role'];

          // Check if business/merchant data exists
          if (businessData == null) {
            debugPrint('❌ User has no business/merchant data');
            state = const AuthError(
                'Akun Anda tidak terhubung dengan merchant. Silakan hubungi administrator.');
            return;
          }

          // Check if store data exists
          if (storeData == null) {
            debugPrint('❌ User has no store data');
            state = const AuthError(
                'Akun Anda tidak terhubung dengan toko. Silakan hubungi administrator.');
            return;
          }

          // Check if role data exists
          if (roleData == null) {
            debugPrint('❌ User has no role data');
            state = const AuthError(
                'Akun Anda tidak memiliki role/permission. Silakan hubungi administrator.');
            return;
          }

          // Business and store data are automatically saved by BusinessStoreService
          // but we can also save additional merchant data if needed
          debugPrint('💾 Business and store data saved to shared preferences');

          state = Authenticated(user);
        } catch (businessError) {
          debugPrint('⚠️ Business data loading failed: $businessError');
          
          // Handle specific business/store/role errors with simple messages
          String errorMessage = 'Terjadi kesalahan saat memuat data. Silakan coba lagi.';
          
          if (businessError.toString().contains('tidak memiliki role assignment')) {
            errorMessage = 'Kamu tidak memiliki akses';
          } else if (businessError.toString().contains('tidak terhubung dengan merchant')) {
            errorMessage = 'Kamu belum memiliki Bisnis';
          } else if (businessError.toString().contains('tidak terhubung dengan toko')) {
            errorMessage = 'Kamu belum memiliki toko';
          } else if (businessError.toString().contains('tidak memiliki role')) {
            errorMessage = 'Kamu tidak memiliki akses';
          }
          
          debugPrint('❌ Login rejected: $errorMessage');
          state = AuthError(errorMessage);
          return;
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
        errorMessage =
            'Pengguna tidak ditemukan. Silakan periksa nama pengguna Anda.';
      } else if (e.toString().contains('Invalid password')) {
        errorMessage = 'Kata sandi salah. Silakan periksa kata sandi Anda.';
      } else if (e.toString().contains('Invalid credentials')) {
        errorMessage =
            'Kredensial salah. Silakan periksa nama pengguna dan kata sandi Anda.';
      } else if (e.toString().contains('inactive')) {
        errorMessage = 'Akun Anda tidak aktif. Silakan hubungi administrator.';
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

      // Clear all data from shared preferences
      try {
        debugPrint('🗑️ Clearing all data from shared preferences...');
        await LocalStorageService.clearAllData();
        debugPrint('✅ All data cleared successfully');
      } catch (clearError) {
        debugPrint('⚠️ Failed to clear data: $clearError');
      }

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

  // Get stored user data from shared preferences
  Future<Map<String, dynamic>?> getStoredUserData() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.execute();
    } catch (e) {
      debugPrint('Failed to get stored user data: $e');
      return null;
    }
  }

  // Get stored user object
  Future<AppUser?> getStoredUser() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.getStoredUser();
    } catch (e) {
      debugPrint('Failed to get stored user: $e');
      return null;
    }
  }

  // Get stored business data
  Future<Map<String, dynamic>?> getStoredBusiness() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.getStoredBusiness();
    } catch (e) {
      debugPrint('Failed to get stored business: $e');
      return null;
    }
  }

  // Get stored store data
  Future<Map<String, dynamic>?> getStoredStore() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.getStoredStore();
    } catch (e) {
      debugPrint('Failed to get stored store: $e');
      return null;
    }
  }

  // Get stored role data
  Future<Map<String, dynamic>?> getStoredRole() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.getStoredRole();
    } catch (e) {
      debugPrint('Failed to get stored role: $e');
      return null;
    }
  }

  // Get stored merchant data
  Future<Map<String, dynamic>?> getStoredMerchant() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.getStoredMerchant();
    } catch (e) {
      debugPrint('Failed to get stored merchant: $e');
      return null;
    }
  }

  // Check if user is logged in (has stored data)
  Future<bool> isUserLoggedIn() async {
    try {
      final getStoredUserDataUseCase =
          ref.read(getStoredUserDataUseCaseProvider);
      return await getStoredUserDataUseCase.isUserLoggedIn();
    } catch (e) {
      debugPrint('Failed to check if user is logged in: $e');
      return false;
    }
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
