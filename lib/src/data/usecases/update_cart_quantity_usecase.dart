import 'package:allnimall_store/src/data/repositories/pos_repository.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';

class UpdateCartQuantityUseCase {
  final PosRepository _posRepository;

  UpdateCartQuantityUseCase(this._posRepository);

  Future<void> call(String productId, int quantity) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) return;
    await _posRepository.updateCartQuantity(storeId, productId, quantity);
  }
}
