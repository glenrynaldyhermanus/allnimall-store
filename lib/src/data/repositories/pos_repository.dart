import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/objects/cart_item.dart';

abstract class PosRepository {
  Future<List<Product>> getProducts();
  Future<List<CartItem>> getStoreCart(String storeId);

  // Product cart operations
  Future<void> addToCart(String storeId, String productId, int quantity);
  Future<void> updateCartQuantity(
      String storeId, String productId, int quantity);
  Future<void> removeFromCart(String storeId, String productId);
  Future<void> clearCart(String storeId);

  // Service booking operations
  Future<void> addServiceToCart({
    required String storeId,
    required String productId,
    required DateTime bookingDate,
    required String bookingTime,
    required int durationMinutes,
    required String assignedStaffId,
    String? customerNotes,
  });

  Future<void> updateServiceBooking({
    required String storeId,
    required String productId,
    DateTime? bookingDate,
    String? bookingTime,
    String? assignedStaffId,
    String? customerNotes,
  });

  // Calendar-style booking operations
  Future<List<Map<String, dynamic>>> getCalendarSlotsWithStaff({
    required String storeId,
    required String serviceProductId,
    required DateTime bookingDate,
    int startHour = 8,
    int endHour = 17,
  });

  Future<bool> isStaffAvailableForRange({
    required String storeId,
    required String serviceProductId,
    required DateTime bookingDate,
    required String staffId,
    required String startTime,
    required int durationMinutes,
  });

  Future<List<Map<String, dynamic>>> getAvailableStaff({
    required String storeId,
    required DateTime date,
    required String time,
  });

  // Unified checkout
  Future<String> processUnifiedCheckout({
    required String cartId,
    required String customerId,
    required String paymentMethodId,
    required String cashierId,
  });
}
