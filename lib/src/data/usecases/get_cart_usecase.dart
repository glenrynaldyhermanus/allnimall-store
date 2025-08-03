import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/repositories/pos_repository.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';

class GetCartUseCase {
  final PosRepository _posRepository;

  GetCartUseCase(this._posRepository);

  Future<List<CartItem>> call() async {
    debugPrint('🛒 [GetCartUseCase] Starting get cart...');
    try {
      debugPrint('🏪 [GetCartUseCase] Getting store ID...');
      final storeId = await SupabaseService.getStoreId();
      debugPrint('🏪 [GetCartUseCase] Store ID: $storeId');
      
      if (storeId == null) {
        debugPrint('❌ [GetCartUseCase] Store ID is null');
        throw Exception('Store ID tidak ditemukan. Pastikan user sudah login dan memiliki akses ke store.');
      }
      
      debugPrint('🛒 [GetCartUseCase] Getting cart from repository...');
      final cartItems = await _posRepository.getStoreCart(storeId);
      debugPrint('🛒 [GetCartUseCase] Cart items loaded: ${cartItems.length} items');
      return cartItems;
    } catch (e) {
      debugPrint('❌ [GetCartUseCase] Error: $e');
      throw Exception('Gagal memuat keranjang: $e');
    }
  }
}
