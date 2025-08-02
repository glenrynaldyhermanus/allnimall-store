import 'package:flutter/foundation.dart';
import 'package:allnimall_store/src/core/services/token_service.dart';

class AppInitializationService {
  /// Initialize aplikasi dan handle token dari URL jika ada
  static Future<bool> initializeApp() async {
    try {
      // Hanya jalankan di web
      if (!kIsWeb) return false;

      // Coba handle token dari URL
      final hasToken = await TokenService.handleTokenFromUrl();

      if (hasToken) {
        return true;
      }

      // Cek apakah ada token yang tersimpan
      final hasStoredToken = await TokenService.isTokenValid();
      if (hasStoredToken) {
        return true;
      }

      // Jika tidak ada valid token, clear semua token yang mungkin invalid
      await TokenService.clearToken();
      return false;
    } catch (e) {
      debugPrint('App initialization error: $e');
      // Jika ada error, clear token dan return false
      await TokenService.clearToken();
      return false;
    }
  }

  /// Generate URL untuk aplikasi Next.js dengan token
  static String generateNextJsUrl({
    required String baseUrl,
    required String token,
    required DateTime expiry,
  }) {
    return TokenService.generateNextJsUrl(baseUrl, token, expiry);
  }
}
