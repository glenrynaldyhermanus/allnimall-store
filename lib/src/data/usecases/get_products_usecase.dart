import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/repositories/pos_repository.dart';

class GetProductsUseCase {
  final PosRepository _posRepository;

  GetProductsUseCase(this._posRepository);

  Future<List<Product>> call() async {
    return await _posRepository.getProducts();
  }
}
