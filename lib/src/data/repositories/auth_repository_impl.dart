import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:allnimall_store/src/data/objects/user.dart';
import 'package:allnimall_store/src/data/repositories/auth_repository.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Future<AppUser?> signIn(String username, String password) async {
    try {
      debugPrint('🔑 Attempting to sign in with username: $username');

      // First, find user by username to get email
      final userResponse = await _supabaseClient
          .from('users')
          .select()
          .eq('username', username)
          .eq('is_active', true)
          .single();

      final email = userResponse['email'];
      if (email == null || email.isEmpty) {
        debugPrint('❌ User has no email configured');
        throw Exception('User has no email configured');
      }

      debugPrint('📧 Found email for user: $email');

      // Sign in with Supabase using email and password
      final authResponse = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (authResponse.user == null) {
        debugPrint('❌ Supabase authentication failed');
        throw Exception('Invalid credentials');
      }

      debugPrint('✅ Supabase authentication successful');

      // Update user's auth_id in database
      await _supabaseClient.from('users').update(
          {'auth_id': authResponse.user!.id}).eq('id', userResponse['id']);

      debugPrint('✅ User authenticated successfully: ${userResponse['name']}');

      // Load and cache user data after successful login
      await SupabaseService.loadUserDataAfterLogin();

      return AppUser.fromJson(userResponse);
    } catch (e) {
      debugPrint('❌ Sign in error: $e');

      // Provide more specific error messages
      if (e.toString().contains('User not found')) {
        throw Exception(
            'Pengguna tidak ditemukan. Silakan periksa nama pengguna Anda.');
      } else if (e.toString().contains('Invalid credentials')) {
        throw Exception('Kata sandi salah. Silakan periksa kata sandi Anda.');
      } else if (e.toString().contains('User has no email configured')) {
        throw Exception(
            'Akun pengguna tidak dikonfigurasi dengan benar. Silakan hubungi administrator.');
      } else if (e.toString().contains('inactive')) {
        throw Exception(
            'Akun Anda tidak aktif. Silakan hubungi administrator.');
      } else {
        throw Exception('Gagal masuk: ${e.toString()}');
      }
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // Clear local storage first
      await LocalStorageService.clearAllData();

      // Then sign out from Supabase
      await _supabaseClient.auth.signOut();
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Gagal keluar');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      // For now, we'll get user from local storage
      // In a real app, you'd validate the session with Supabase
      final userData = await LocalStorageService.getUserData();
      if (userData == null) return null;

      return AppUser.fromJson(userData);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final userData = await LocalStorageService.getUserData();
      return userData != null;
    } catch (e) {
      // TODO: gunakan logger jika perlu
      return false;
    }
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      // Coba recover session dengan token
      await _supabaseClient.auth.recoverSession(token);
      final user = _supabaseClient.auth.currentUser;
      return user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AppUser?> authenticateWithToken(String token) async {
    try {
      // Set session dengan token
      await SupabaseService.setSessionToken(token);

      // Load user data setelah authentication
      await SupabaseService.loadUserDataAfterLogin();

      // Get current user
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;

      // Get user data from users table using auth_id
      final userResponse = await _supabaseClient
          .from('users')
          .select()
          .eq('auth_id', user.id)
          .eq('is_active', true)
          .single();

      return AppUser.fromJson(userResponse);
    } catch (e) {
      return null;
    }
  }
}
