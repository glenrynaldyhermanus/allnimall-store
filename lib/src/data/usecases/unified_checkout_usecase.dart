import 'package:allnimall_store/src/data/repositories/pos_repository.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';

class UnifiedCheckoutUseCase {
  final PosRepository _posRepository;

  UnifiedCheckoutUseCase(this._posRepository);

  // Process unified checkout (products + services)
  Future<String> execute({
    required String customerId,
    required String paymentMethodId,
    required String cashierId,
  }) async {
    final storeId = await SupabaseService.getStoreId();
    if (storeId == null) {
      throw Exception('Store ID tidak ditemukan');
    }
    
    // Get cart ID from repository
    final cartId = await _getCartId(storeId);
    if (cartId == null) {
      throw Exception('Cart tidak ditemukan');
    }
    
    // Process unified checkout
    final saleId = await _posRepository.processUnifiedCheckout(
      cartId: cartId,
      customerId: customerId,
      paymentMethodId: paymentMethodId,
      cashierId: cashierId,
    );
    
    return saleId;
  }

  // Get cart ID for the store
  Future<String?> _getCartId(String storeId) async {
    try {
      final response = await SupabaseService.client
          .from('store_carts')
          .select('id')
          .eq('store_id', storeId)
          .eq('status', 'active')
          .maybeSingle();
      
      return response?['id'] as String?;
    } catch (e) {
      return null;
    }
  }

  // Validate checkout data
  Future<Map<String, dynamic>> validateCheckout({
    required String customerId,
    required String paymentMethodId,
  }) async {
    final results = <String, dynamic>{};
    
    // Check if customer exists
    final customerExists = await _checkCustomerExists(customerId);
    results['customerValid'] = customerExists;
    
    // Check if payment method exists
    final paymentMethodExists = await _checkPaymentMethodExists(paymentMethodId);
    results['paymentMethodValid'] = paymentMethodExists;
    
    // Check if cart has items
    final storeId = await SupabaseService.getStoreId();
    if (storeId != null) {
      final cartItems = await _getCartItems(storeId);
      results['hasItems'] = cartItems.isNotEmpty;
      results['itemCount'] = cartItems.length;
    } else {
      results['hasItems'] = false;
      results['itemCount'] = 0;
    }
    
    // Overall validation
    results['isValid'] = customerExists && paymentMethodExists && results['hasItems'];
    
    return results;
  }

  // Check if customer exists
  Future<bool> _checkCustomerExists(String customerId) async {
    try {
      final response = await SupabaseService.client
          .from('customers')
          .select('id')
          .eq('id', customerId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Check if payment method exists
  Future<bool> _checkPaymentMethodExists(String paymentMethodId) async {
    try {
      final response = await SupabaseService.client
          .from('payment_methods')
          .select('id')
          .eq('id', paymentMethodId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      return false;
    }
  }

  // Get cart items count
  Future<List<Map<String, dynamic>>> _getCartItems(String storeId) async {
    try {
      final cartId = await _getCartId(storeId);
      if (cartId == null) return [];
      
      final response = await SupabaseService.client
          .from('store_cart_items')
          .select('*')
          .eq('cart_id', cartId);
      
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }
} 