import 'package:allnimall_store/src/data/objects/user.dart';
import 'package:allnimall_store/src/data/repositories/auth_repository.dart';

class GetCurrentUserUseCase {
  final AuthRepository _authRepository;

  GetCurrentUserUseCase(this._authRepository);

  Future<AppUser?> call() async {
    return await _authRepository.getCurrentUser();
  }
}
