import 'package:allnimall_store/src/data/repositories/pos_repository.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';

class AddToCartUseCase {
  final PosRepository _posRepository;

  AddToCartUseCase(this._posRepository);

  // Add product to cart
  Future<void> call(String productId, int quantity) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) return;
    await _posRepository.addToCart(storeId, productId, quantity);
  }
  
  // Add service to cart with booking details
  Future<void> addService({
    required String productId,
    required DateTime bookingDate,
    required String bookingTime,
    required int durationMinutes,
    required String assignedStaffId,
    String? customerNotes,
  }) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) return;
    
    await _posRepository.addServiceToCart(
      storeId: storeId,
      productId: productId,
      bookingDate: bookingDate,
      bookingTime: bookingTime,
      durationMinutes: durationMinutes,
      assignedStaffId: assignedStaffId,
      customerNotes: customerNotes,
    );
  }
}
