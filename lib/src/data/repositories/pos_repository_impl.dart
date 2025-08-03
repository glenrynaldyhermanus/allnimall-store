import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'pos_repository.dart';

class PosRepositoryImpl implements PosRepository {
  final SupabaseClient _supabaseClient;

  PosRepositoryImpl(this._supabaseClient);

  @override
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

  @override
  Future<List<CartItem>> getStoreCart(String storeId) async {
    debugPrint('🛒 [PosRepositoryImpl] Starting getStoreCart for store: $storeId');
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

      debugPrint('🛒 [PosRepositoryImpl] Cart items response: $cartItemsResponse');
      
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

      debugPrint('🛒 [PosRepositoryImpl] Final cart items: ${cartItems.length} items');
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
        .select('id')
        .single();

    return newCart['id'] as String;
  }

  @override
  Future<void> addToCart(String storeId, String productId, int quantity) async {
    debugPrint('🛒 [PosRepositoryImpl] addToCart called with storeId: $storeId, productId: $productId, quantity: $quantity');
    
    try {
      // Validate inputs
      if (storeId.isEmpty) {
        throw Exception('Store ID tidak boleh kosong');
      }
      if (productId.isEmpty) {
        throw Exception('Product ID tidak boleh kosong');
      }
      if (quantity <= 0) {
        throw Exception('Quantity harus lebih dari 0');
      }

      // Check if store exists
      debugPrint('🛒 [PosRepositoryImpl] Checking if store exists...');
      final storeExists = await _supabaseClient
          .from('stores')
          .select('id')
          .eq('id', storeId)
          .maybeSingle();
      
      if (storeExists == null) {
        throw Exception('Store tidak ditemukan');
      }

      // Check if product exists
      debugPrint('🛒 [PosRepositoryImpl] Checking if product exists...');
      final productExists = await _supabaseClient
          .from('products')
          .select('id, price')
          .eq('id', productId)
          .eq('store_id', storeId)
          .maybeSingle();
      
      if (productExists == null) {
        throw Exception('Product tidak ditemukan di store ini');
      }

      // Get or create active cart
      final cartId = await _getOrCreateActiveCart(storeId);
      debugPrint('🛒 [PosRepositoryImpl] Using cart ID: $cartId');

      // Check if product already in cart
      debugPrint('🛒 [PosRepositoryImpl] Checking if product already in cart...');
      final existingCartItem = await _supabaseClient
          .from('store_cart_items')
          .select()
          .eq('cart_id', cartId)
          .eq('product_id', productId)
          .maybeSingle();

      debugPrint('🛒 [PosRepositoryImpl] Existing cart item result: $existingCartItem');

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
        };
        debugPrint('🛒 [PosRepositoryImpl] Insert data: $insertData');
        
        await _supabaseClient.from('store_cart_items').insert(insertData);
        debugPrint('🛒 [PosRepositoryImpl] New cart item inserted successfully');
      }
    } catch (e) {
      debugPrint('❌ [PosRepositoryImpl] Error in addToCart: $e');
      debugPrint('❌ [PosRepositoryImpl] Error type: ${e.runtimeType}');
      debugPrint('❌ [PosRepositoryImpl] Error details: $e');
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to add to cart: $e');
    }
  }

  @override
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

  @override
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

  @override
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
