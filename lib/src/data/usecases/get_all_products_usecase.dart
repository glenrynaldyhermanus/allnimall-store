import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/repositories/management_repository.dart';

class GetAllProductsUseCase {
  final ManagementRepository _managementRepository;

  GetAllProductsUseCase(this._managementRepository);

  Future<List<Product>> execute() async {
    return await _managementRepository.getAllProducts();
  }
}
