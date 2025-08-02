import 'package:allnimall_store/src/data/objects/user.dart';
import 'package:allnimall_store/src/data/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  Future<AppUser?> call(String username, String password) async {
    return await _authRepository.signIn(username, password);
  }
}
