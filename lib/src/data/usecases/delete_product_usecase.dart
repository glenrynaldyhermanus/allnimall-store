import 'package:allnimall_store/src/data/repositories/management_repository.dart';

class DeleteProductUseCase {
  final ManagementRepository _repository;

  DeleteProductUseCase(this._repository);

  Future<void> execute(String productId) async {
    await _repository.deleteProduct(productId);
  }
}
