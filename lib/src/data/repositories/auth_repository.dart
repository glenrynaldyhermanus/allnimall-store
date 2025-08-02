import 'package:allnimall_store/src/data/objects/user.dart';

abstract class AuthRepository {
  Future<AppUser?> signIn(String username, String password);
  Future<void> signOut();
  Future<AppUser?> getCurrentUser();
  Future<bool> isAuthenticated();
  Future<bool> validateToken(String token);
  Future<AppUser?> authenticateWithToken(String token);
}
