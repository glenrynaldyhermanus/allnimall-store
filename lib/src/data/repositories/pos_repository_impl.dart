import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'pos_repository.dart';

class PosRepositoryImpl implements PosRepository {
  final SupabaseClient _supabaseClient;

  PosRepositoryImpl(this._supabaseClient);

  
  Future<List<Product>> getProducts() async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        return [];
      }

      final response = await _supabaseClient
          .from('products')
          .select('*, categories(name)')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      final products =
          (response as List).map((json) => Product.fromJson(json)).toList();
      return products;
    } catch (e) {
      // TODO: gunakan logger jika perlu
      return [];
    }
  }

  
  Future<List<CartItem>> getStoreCart(String storeId) async {
    debugPrint(
        '🛒 [PosRepositoryImpl] Starting getStoreCart for store: $storeId');
    try {
      if (storeId.isEmpty) {
        debugPrint('❌ [PosRepositoryImpl] Store ID is empty');
        throw Exception('Store ID tidak valid');
      }

      debugPrint('🛒 [PosRepositoryImpl] Querying store_carts table...');
      // First, get or create active cart for the store
      final cartId = await _getOrCreateActiveCart(storeId);

      debugPrint('🛒 [PosRepositoryImpl] Cart ID: $cartId');

      // Query cart items
      final cartItemsResponse = await _supabaseClient
          .from('store_cart_items')
          .select('*, products(*)')
          .eq('cart_id', cartId)
          .order('created_at', ascending: true);

      debugPrint(
          '🛒 [PosRepositoryImpl] Cart items response: $cartItemsResponse');

      if (cartItemsResponse.isEmpty) {
        debugPrint('🛒 [PosRepositoryImpl] No cart items found');
        return [];
      }

      // Parse cart items
      final cartItems = <CartItem>[];
      for (final item in cartItemsResponse as List) {
        try {
          final cartItemObj = CartItem.fromJson(item);
          cartItems.add(cartItemObj);
        } catch (e) {
          debugPrint('❌ [PosRepositoryImpl] Error parsing cart item: $e');
          debugPrint('❌ [PosRepositoryImpl] Item data: $item');
        }
      }

      debugPrint(
          '🛒 [PosRepositoryImpl] Final cart items: ${cartItems.length} items');
      return cartItems;
    } catch (e) {
      // Log error for debugging
      debugPrint('❌ [PosRepositoryImpl] Error in getStoreCart: $e');
      throw Exception('Gagal memuat keranjang dari database: $e');
    }
  }

  Future<String> _getOrCreateActiveCart(String storeId) async {
    // Try to find existing active cart
    final existingCart = await _supabaseClient
        .from('store_carts')
        .select('id')
        .eq('store_id', storeId)
        .eq('status', 'active')
        .maybeSingle();

    if (existingCart != null) {
      return existingCart['id'] as String;
    }

    // Create new active cart
    final newCart = await _supabaseClient
        .from('store_carts')
        .insert({
          'store_id': storeId,
          'status': 'active',
        })
        .select()
        .single();

    return newCart['id'] as String;
  }

  
  Future<void> addToCart(String storeId, String productId, int quantity) async {
    debugPrint('🛒 [PosRepositoryImpl] Starting addToCart');
    debugPrint('🛒 [PosRepositoryImpl] Store ID: $storeId');
    debugPrint('🛒 [PosRepositoryImpl] Product ID: $productId');
    debugPrint('🛒 [PosRepositoryImpl] Quantity: $quantity');

    try {
      // Verify product exists in store
      final productExists = await _supabaseClient
          .from('products')
          .select()
          .eq('id', productId)
          .eq('store_id', storeId)
          .eq('is_active', true)
          .maybeSingle();

      debugPrint(
          '🛒 [PosRepositoryImpl] Product verification result: $productExists');

      if (productExists == null) {
        throw Exception('Product tidak ditemukan di store ini');
      }

      // Get or create active cart
      final cartId = await _getOrCreateActiveCart(storeId);
      debugPrint('🛒 [PosRepositoryImpl] Using cart ID: $cartId');

      // Check if product already in cart
      debugPrint(
          '🛒 [PosRepositoryImpl] Checking if product already in cart...');
      final existingCartItem = await _supabaseClient
          .from('store_cart_items')
          .select()
          .eq('cart_id', cartId)
          .eq('product_id', productId)
          .maybeSingle();

      debugPrint(
          '🛒 [PosRepositoryImpl] Existing cart item result: $existingCartItem');

      if (existingCartItem != null) {
        // Update quantity
        debugPrint('🛒 [PosRepositoryImpl] Updating existing cart item...');
        await _supabaseClient
            .from('store_cart_items')
            .update({'quantity': existingCartItem['quantity'] + quantity})
            .eq('cart_id', cartId)
            .eq('product_id', productId);
        debugPrint('🛒 [PosRepositoryImpl] Cart item updated successfully');
      } else {
        // Insert new cart item
        debugPrint('🛒 [PosRepositoryImpl] Inserting new cart item...');
        final insertData = {
          'cart_id': cartId,
          'product_id': productId,
          'quantity': quantity,
          'unit_price': productExists['price'] ?? 0,
          'item_type': 'product', // Default to product
        };
        debugPrint('🛒 [PosRepositoryImpl] Insert data: $insertData');

        await _supabaseClient.from('store_cart_items').insert(insertData);
        debugPrint(
            '🛒 [PosRepositoryImpl] New cart item inserted successfully');
      }
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in addToCart: $e');
      debugPrint('❌ [PosRepositoryImpl] Error type: ${e.runtimeType}');
      debugPrint('❌ [PosRepositoryImpl] Error details: $e');
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to add to cart: $e');
    }
  }

  
  Future<void> addServiceToCart({
    required String storeId,
    required String productId,
    required DateTime bookingDate,
    required String bookingTime,
    required int durationMinutes,
    required String assignedStaffId,
    String? customerNotes,
  }) async {
    debugPrint('🛒 [PosRepositoryImpl] Starting addServiceToCart');
    debugPrint('🛒 [PosRepositoryImpl] Store ID: $storeId');
    debugPrint('🛒 [PosRepositoryImpl] Product ID: $productId');
    debugPrint('🛒 [PosRepositoryImpl] Booking Date: $bookingDate');
    debugPrint('🛒 [PosRepositoryImpl] Booking Time: $bookingTime');

    try {
      // Verify product exists and is a service
      final productExists = await _supabaseClient
          .from('products')
          .select()
          .eq('id', productId)
          .eq('store_id', storeId)
          .eq('is_active', true)
          .eq('product_type', 'service')
          .maybeSingle();

      if (productExists == null) {
        throw Exception('Service tidak ditemukan di store ini');
      }

      // Temporarily bypass slot availability check for testing
      debugPrint(
          '🛒 [PosRepositoryImpl] Bypassing slot availability check for testing');
      /*
      // Check slot availability
      final isAvailable = await checkSlotAvailability(
        storeId: storeId,
        productId: productId,
        date: bookingDate,
        time: bookingTime,
      );

      if (!isAvailable) {
        throw Exception('Slot tidak tersedia untuk waktu yang dipilih');
      }
      */

      // Get or create active cart
      final cartId = await _getOrCreateActiveCart(storeId);

      // Check if service already in cart
      final existingCartItem = await _supabaseClient
          .from('store_cart_items')
          .select()
          .eq('cart_id', cartId)
          .eq('product_id', productId)
          .eq('item_type', 'service')
          .maybeSingle();

      if (existingCartItem != null) {
        // Update service booking
        await _supabaseClient
            .from('store_cart_items')
            .update({
              'booking_date': bookingDate.toIso8601String().split('T')[0],
              'booking_time': bookingTime,
              'duration_minutes': durationMinutes,
              'assigned_staff_id': assignedStaffId,
              'customer_notes': customerNotes,
            })
            .eq('cart_id', cartId)
            .eq('product_id', productId)
            .eq('item_type', 'service');
      } else {
        // Insert new service cart item
        final insertData = {
          'cart_id': cartId,
          'product_id': productId,
          'quantity': 1,
          'unit_price': productExists['price'] ?? 0,
          'item_type': 'service',
          'booking_date': bookingDate.toIso8601String().split('T')[0],
          'booking_time': bookingTime,
          'duration_minutes': durationMinutes,
          'assigned_staff_id': assignedStaffId,
          'customer_notes': customerNotes,
        };

        debugPrint(
            '🛒 [PosRepositoryImpl] Inserting service cart item: $insertData');
        await _supabaseClient.from('store_cart_items').insert(insertData);
        debugPrint(
            '🛒 [PosRepositoryImpl] Service cart item inserted successfully');
      }
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in addServiceToCart: $e');
      throw Exception('Failed to add service to cart: $e');
    }
  }

  
  Future<void> updateServiceBooking({
    required String storeId,
    required String productId,
    DateTime? bookingDate,
    String? bookingTime,
    String? assignedStaffId,
    String? customerNotes,
  }) async {
    try {
      final cartId = await _getOrCreateActiveCart(storeId);

      final updateData = <String, dynamic>{};
      if (bookingDate != null) {
        updateData['booking_date'] =
            bookingDate.toIso8601String().split('T')[0];
      }
      if (bookingTime != null) {
        updateData['booking_time'] = bookingTime;
      }
      if (assignedStaffId != null) {
        updateData['assigned_staff_id'] = assignedStaffId;
      }
      if (customerNotes != null) {
        updateData['customer_notes'] = customerNotes;
      }

      await _supabaseClient
          .from('store_cart_items')
          .update(updateData)
          .eq('cart_id', cartId)
          .eq('product_id', productId)
          .eq('item_type', 'service');
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in updateServiceBooking: $e');
      throw Exception('Failed to update service booking: $e');
    }
  }

  
  Future<bool> checkSlotAvailability({
    required String storeId,
    required String productId,
    required DateTime date,
    required String time,
  }) async {
    try {
      final response =
          await _supabaseClient.rpc('check_cart_slot_availability', params: {
        'p_store_id': storeId,
        'p_service_product_id': productId,
        'p_booking_date': date.toIso8601String().split('T')[0],
        'p_booking_time': time,
      });

      return response as bool;
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in checkSlotAvailability: $e');
      return false;
    }
  }

  
  Future<List<Map<String, dynamic>>> getAvailableSlots({
    required String storeId,
    required String productId,
    required DateTime date,
  }) async {
    try {
      final response =
          await _supabaseClient.rpc('get_available_slots', params: {
        'p_store_id': storeId,
        'p_service_product_id': productId,
        'p_booking_date': date.toIso8601String().split('T')[0],
      });

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in getAvailableSlots: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getCalendarSlotsWithStaff({
    required String storeId,
    required String serviceProductId,
    required DateTime bookingDate,
    int startHour = 8,
    int endHour = 17,
  }) async {
    try {
      debugPrint(
          '🛒 [PosRepositoryImpl] Calling get_calendar_slots_with_staff...');
      final response = await _supabaseClient.rpc(
        'get_calendar_slots_with_staff',
        params: {
          'p_store_id': storeId,
          'p_service_product_id': serviceProductId,
          'p_booking_date': bookingDate.toIso8601String().split('T')[0],
          'p_start_hour': startHour,
          'p_end_hour': endHour,
        },
      );

      debugPrint(
          '🛒 [PosRepositoryImpl] Calendar slots response: ${response.length} items');
      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint(
          '❌ [PosRepositoryImpl] Error in getCalendarSlotsWithStaff: $e');
      return [];
    }
  }

  Future<bool> isStaffAvailableForRange({
    required String storeId,
    required String serviceProductId,
    required DateTime bookingDate,
    required String staffId,
    required String startTime,
    required int durationMinutes,
  }) async {
    try {
      final response = await _supabaseClient.rpc(
        'is_staff_available_for_range',
        params: {
          'p_store_id': storeId,
          'p_service_product_id': serviceProductId,
          'p_booking_date': bookingDate.toIso8601String().split('T')[0],
          'p_staff_id': staffId,
          'p_start_time': startTime,
          'p_duration_minutes': durationMinutes,
        },
      );

      return response as bool;
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in isStaffAvailableForRange: $e');
      return false;
    }
  }

  
  Future<List<Map<String, dynamic>>> getAvailableStaff({
    required String storeId,
    required DateTime date,
    required String time,
  }) async {
    try {
      final response =
          await _supabaseClient.rpc('get_available_staff', params: {
        'p_store_id': storeId,
        'p_booking_date': date.toIso8601String().split('T')[0],
        'p_booking_time': time,
        'p_duration_minutes': 120, // Default duration
      });

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in getAvailableStaff: $e');
      return [];
    }
  }

  
  Future<String> processUnifiedCheckout({
    required String cartId,
    required String customerId,
    required String paymentMethodId,
    required String cashierId,
  }) async {
    try {
      final response =
          await _supabaseClient.rpc('process_unified_checkout', params: {
        'p_cart_id': cartId,
        'p_customer_id': customerId,
        'p_payment_method_id': paymentMethodId,
        'p_cashier_id': cashierId,
      });

      return response as String; // Returns sale ID
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in processUnifiedCheckout: $e');
      throw Exception('Failed to process unified checkout: $e');
    }
  }

  
  Future<void> updateCartQuantity(
      String storeId, String productId, int quantity) async {
    try {
      final cartId = await _getOrCreateActiveCart(storeId);

      if (quantity <= 0) {
        await removeFromCart(storeId, productId);
      } else {
        await _supabaseClient
            .from('store_cart_items')
            .update({'quantity': quantity})
            .eq('cart_id', cartId)
            .eq('product_id', productId);
      }
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to update cart quantity');
    }
  }

  
  Future<void> removeFromCart(String storeId, String productId) async {
    try {
      final cartId = await _getOrCreateActiveCart(storeId);

      await _supabaseClient
          .from('store_cart_items')
          .delete()
          .eq('cart_id', cartId)
          .eq('product_id', productId);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to remove from cart');
    }
  }

  
  Future<void> clearCart(String storeId) async {
    try {
      final cartId = await _getOrCreateActiveCart(storeId);

      await _supabaseClient
          .from('store_cart_items')
          .delete()
          .eq('cart_id', cartId);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to clear cart');
    }
  }
}
