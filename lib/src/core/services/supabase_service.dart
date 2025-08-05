import 'package:supabase_flutter/supabase_flutter.dart';
import 'local_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  // Products
  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      final response = await client
          .from('products')
          .select('*, categories(name)')
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      return [];
    }
  }

  // Store Cart
  static Future<List<Map<String, dynamic>>> getStoreCart(String storeId) async {
    try {
      final response = await client
          .from('store_carts')
          .select('*, products(*)')
          .eq('store_id', storeId);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      return [];
    }
  }

  static Future<void> addToCart(
      String storeId, String productId, int quantity) async {
    try {
      // Check if product already in cart
      final existingCart = await client
          .from('store_carts')
          .select()
          .eq('store_id', storeId)
          .eq('product_id', productId)
          .single();

      // Update quantity
      await client
          .from('store_carts')
          .update({'quantity': existingCart['quantity'] + quantity})
          .eq('store_id', storeId)
          .eq('product_id', productId);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to add to cart');
    }
  }

  static Future<void> updateCartQuantity(
      String storeId, String productId, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeFromCart(storeId, productId);
      } else {
        await client
            .from('store_carts')
            .update({'quantity': quantity})
            .eq('store_id', storeId)
            .eq('product_id', productId);
      }
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to update cart quantity');
    }
  }

  static Future<void> removeFromCart(String storeId, String productId) async {
    try {
      await client
          .from('store_carts')
          .delete()
          .eq('store_id', storeId)
          .eq('product_id', productId);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to remove from cart');
    }
  }

  static Future<void> clearCart(String storeId) async {
    try {
      await client.from('store_carts').delete().eq('store_id', storeId);
    } catch (e) {
      // TODO: gunakan logger jika perlu
      throw Exception('Failed to clear cart');
    }
  }

  // User Profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final user = client.auth.currentUser;
      if (user == null) return null;
      return {
        'id': user.id,
        'email': user.email,
        'name': user.userMetadata?['name'],
        'avatar': user.userMetadata?['avatar'],
      };
    } catch (e) {
      // TODO: gunakan logger jika perlu
      return null;
    }
  }

  // Get user's store ID from local storage first, then from database if needed
  static Future<String?> getStoreId() async {
    debugPrint('🏪 [SupabaseService] Getting store ID...');

    // Try to get from local storage first (more efficient)
    final storeId = await LocalStorageService.getStoreId();
    debugPrint('🏪 [SupabaseService] Store ID from local storage: $storeId');

    if (storeId != null) {
      debugPrint('✅ [SupabaseService] Store ID found in local storage');
      return storeId;
    }

    debugPrint(
        '🔄 [SupabaseService] Store ID not in local storage, getting from database...');

    // If not in local storage, get from database and cache it
    try {
      final user = client.auth.currentUser;
      debugPrint('👤 [SupabaseService] Current user: ${user?.email}');

      if (user == null) {
        debugPrint('❌ [SupabaseService] No current user found');
        return null;
      }

      // First, get the user from our users table using auth_id
      debugPrint('👤 [SupabaseService] Getting user from users table...');
      final userResponse = await client
          .from('users')
          .select('id')
          .eq('auth_id', user.id)
          .eq('is_active', true)
          .single();

      final userId = userResponse['id'];
      debugPrint('👤 [SupabaseService] User ID from database: $userId');

      // Now query role_assignments using the user ID from our users table
      debugPrint('🔍 [SupabaseService] Getting role assignment...');
      final response = await client
          .from('role_assignments')
          .select('store_id')
          .eq('user_id', userId)
          .eq('is_active', true)
          .limit(1)
          .single();

      final storeIdFromDb = response['store_id'];
      debugPrint('🏪 [SupabaseService] Store ID from database: $storeIdFromDb');

      // Cache the store ID for future use
      if (storeIdFromDb != null) {
        debugPrint('💾 [SupabaseService] Caching store ID...');
        await LocalStorageService.saveRoleAssignmentData(
            {'store_id': storeIdFromDb});
        debugPrint('✅ [SupabaseService] Store ID cached successfully');
      }

      return storeIdFromDb;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error getting store ID: $e');
      // TODO: gunakan logger jika perlu
      return null;
    }
  }

  // Load and cache user data after successful login
  static Future<void> loadUserDataAfterLogin() async {
    try {
      debugPrint('📊 Loading user data after login...');
      final user = client.auth.currentUser;
      if (user == null) {
        debugPrint('❌ No current user found during data loading');
        return;
      }

      debugPrint('👤 Current user: ${user.email}');

      // First, get the user from our users table using auth_id
      final userResponse = await client
          .from('users')
          .select('id, name, email, username, auth_id')
          .eq('auth_id', user.id)
          .eq('is_active', true)
          .single();

      final userId = userResponse['id'];
      debugPrint('👤 Found user in database: $userId');

      // Get user data
      final userData = {
        'id': userId, // Use user ID from our users table
        'email': user.email,
        'name': userResponse['name'],
        'username': userResponse['username'],
        'avatar': user.userMetadata?['avatar_url'],
      };
      await LocalStorageService.saveUserData(userData);
      debugPrint('💾 User data saved to local storage');

      // Get role assignment data using user ID from our users table
      debugPrint('🔍 Fetching role assignment data...');
      final roleResponse = await client
          .from('role_assignments')
          .select('*, merchants(*), stores(*)')
          .eq('user_id', userId)
          .eq('is_active', true)
          .limit(1)
          .single();

      await LocalStorageService.saveRoleAssignmentData(roleResponse);
      debugPrint('💾 Role assignment data saved to local storage');

      // Save merchant data
      final merchantData = roleResponse['merchants'];
      if (merchantData != null) {
        await LocalStorageService.saveBusinessData(merchantData);
        debugPrint('💾 Merchant data saved to local storage');
      }

      // Save store data
      final storeData = roleResponse['stores'];
      if (storeData != null) {
        await LocalStorageService.saveStoreData(storeData);
        debugPrint('💾 Store data saved to local storage');
      }

      debugPrint('✅ User data loading completed successfully');
    } catch (e) {
      debugPrint('❌ Error in loadUserDataAfterLogin: $e');
      // Don't throw exception here to avoid breaking the login flow
    }
  }

  // Set session token for external authentication
  static Future<void> setSessionToken(String token) async {
    try {
      // Decode the JWT token to extract user information
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token format');
      }

      // Method 1: Try using refreshSession with a dummy refresh token
      // This is a workaround since we only have access token
      try {
        await client.auth.refreshSession(token);
        // Session token set successfully via refreshSession
        return;
      } catch (e) {
        // refreshSession failed: $e
      }

      // Method 2: Try setSession with access_token format
      try {
        // Format as session object
        await client.auth.setSession(token);
        // Session token set successfully via setSession
        return;
      } catch (e) {
        // setSession failed: $e
      }

      // Method 3: Get user info and manually trigger auth state change
      final response = await client.auth.getUser(token);

      if (response.user != null) {
        // Session token set successfully via getUser
        // Current user after getUser: ${response.user!.email}
      } else {
        throw Exception('Invalid token - no user found');
      }
    } catch (e) {
      // Error setting session token: $e
      throw Exception('Failed to set session token: ${e.toString()}');
    }
  }

  // Check if user is authenticated
  static Future<bool> isUserAuthenticated() async {
    debugPrint('🔐 [SupabaseService] Checking user authentication...');
    try {
      final user = client.auth.currentUser;
      final isAuthenticated = user != null;
      debugPrint('🔐 [SupabaseService] User authenticated: $isAuthenticated');
      if (isAuthenticated) {
        debugPrint('👤 [SupabaseService] User email: ${user.email}');
      }
      return isAuthenticated;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error checking user authentication: $e');
      return false;
    }
  }

  // Upload file to Supabase Storage
  static Future<String?> uploadProductImage(
      File imageFile, String storeId) async {
    try {
      debugPrint('📤 [SupabaseService] Uploading product image...');

      // Generate unique filename
      final uuid = const Uuid();
      final fileName = '${uuid.v4()}.jpg';
      final filePath = '$storeId/$fileName';

      debugPrint('📁 [SupabaseService] File path: $filePath');

      // Upload to Supabase Storage
      await client.storage
          .from('merchants_products')
          .upload(filePath, imageFile);

      debugPrint('✅ [SupabaseService] File uploaded successfully');

      // Get public URL
      final publicUrl =
          client.storage.from('merchants_products').getPublicUrl(filePath);

      debugPrint('🔗 [SupabaseService] Public URL: $publicUrl');

      return publicUrl;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error uploading file: $e');
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  // Create new product
  static Future<Map<String, dynamic>?> createProduct(
      Map<String, dynamic> productData) async {
    try {
      debugPrint('➕ [SupabaseService] Creating new product...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      // Add store_id to product data
      productData['store_id'] = storeId;
      productData['created_at'] = DateTime.now().toIso8601String();
      productData['updated_at'] = DateTime.now().toIso8601String();

      debugPrint('📊 [SupabaseService] Product data: $productData');

      // Insert product to database
      final response =
          await client.from('products').insert(productData).select().single();

      debugPrint('✅ [SupabaseService] Product created successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error creating product: $e');
      throw Exception('Failed to create product: ${e.toString()}');
    }
  }

  // Update product
  static Future<Map<String, dynamic>?> updateProduct(
      String productId, Map<String, dynamic> productData) async {
    try {
      debugPrint('✏️ [SupabaseService] Updating product: $productId');

      // Add updated_at timestamp
      productData['updated_at'] = DateTime.now().toIso8601String();

      debugPrint('📊 [SupabaseService] Product data: $productData');

      // Update product in database
      final response = await client
          .from('products')
          .update(productData)
          .eq('id', productId)
          .select()
          .single();

      debugPrint('✅ [SupabaseService] Product updated successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error updating product: $e');
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }

  // Soft delete product
  static Future<bool> softDeleteProduct(String productId) async {
    try {
      debugPrint('🗑️ [SupabaseService] Soft deleting product: $productId');

      // Get current user ID for deleted_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Update product with soft delete data
      await client.from('products').update({
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by': userId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', productId);

      debugPrint('✅ [SupabaseService] Product soft deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error soft deleting product: $e');
      throw Exception('Failed to soft delete product: ${e.toString()}');
    }
  }

  // Get product by ID
  static Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      debugPrint('🔍 [SupabaseService] Getting product: $productId');

      final response =
          await client.from('products').select().eq('id', productId).single();

      debugPrint('✅ [SupabaseService] Product retrieved successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error getting product: $e');
      return null;
    }
  }

  // Categories
  static Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      debugPrint('📂 [SupabaseService] Getting categories...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await client
          .from('products_categories')
          .select('*, products(count)')
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      debugPrint('✅ [SupabaseService] Categories retrieved successfully');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error getting categories: $e');
      return [];
    }
  }

  // Create new category
  static Future<Map<String, dynamic>?> createCategory(
      String name, String description, String type) async {
    try {
      debugPrint('➕ [SupabaseService] Creating new category...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      // Prepare category data
      final categoryData = {
        'name': name,
        'description': description,
        'type': type,
        'store_id': storeId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📊 [SupabaseService] Category data: $categoryData');

      // Insert category to database
      final response = await client
          .from('products_categories')
          .insert(categoryData)
          .select()
          .single();

      debugPrint('✅ [SupabaseService] Category created successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error creating category: $e');
      throw Exception('Failed to create category: ${e.toString()}');
    }
  }

  // Update category
  static Future<Map<String, dynamic>?> updateCategory(
      String categoryId, String name, String description, String type) async {
    try {
      debugPrint('✏️ [SupabaseService] Updating category: $categoryId');

      // Prepare category data
      final categoryData = {
        'name': name,
        'description': description,
        'type': type,
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📊 [SupabaseService] Category data: $categoryData');

      // Update category in database
      final response = await client
          .from('products_categories')
          .update(categoryData)
          .eq('id', categoryId)
          .select()
          .single();

      debugPrint('✅ [SupabaseService] Category updated successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error updating category: $e');
      throw Exception('Failed to update category: ${e.toString()}');
    }
  }

  // Soft delete category
  static Future<bool> softDeleteCategory(String categoryId) async {
    try {
      debugPrint('🗑️ [SupabaseService] Soft deleting category: $categoryId');

      // Get current user ID for deleted_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Update category with soft delete data
      await client.from('products_categories').update({
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by': userId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', categoryId);

      debugPrint('✅ [SupabaseService] Category soft deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error soft deleting category: $e');
      throw Exception('Failed to soft delete category: ${e.toString()}');
    }
  }

  // Customers
  static Future<List<Map<String, dynamic>>> getCustomers() async {
    try {
      debugPrint('👥 [SupabaseService] Getting customers...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await client
          .from('customers')
          .select('*')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      debugPrint('✅ [SupabaseService] Customers retrieved successfully');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error getting customers: $e');
      return [];
    }
  }

  // Create new customer
  static Future<Map<String, dynamic>?> createCustomer(
      Map<String, dynamic> customerData) async {
    try {
      debugPrint('➕ [SupabaseService] Creating new customer...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      // Get current user ID for created_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare customer data
      final data = {
        ...customerData,
        'store_id': storeId,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📊 [SupabaseService] Customer data: $data');

      // Insert customer to database
      final response =
          await client.from('customers').insert(data).select().single();

      debugPrint('✅ [SupabaseService] Customer created successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error creating customer: $e');
      throw Exception('Failed to create customer: ${e.toString()}');
    }
  }

  // Update customer
  static Future<Map<String, dynamic>?> updateCustomer(
      String customerId, Map<String, dynamic> customerData) async {
    try {
      debugPrint('✏️ [SupabaseService] Updating customer: $customerId');

      // Get current user ID for updated_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare customer data
      final data = {
        ...customerData,
        'updated_by': userId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📊 [SupabaseService] Customer data: $data');

      // Update customer in database
      final response = await client
          .from('customers')
          .update(data)
          .eq('id', customerId)
          .select()
          .single();

      debugPrint('✅ [SupabaseService] Customer updated successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error updating customer: $e');
      throw Exception('Failed to update customer: ${e.toString()}');
    }
  }

  // Soft delete customer
  static Future<bool> softDeleteCustomer(String customerId) async {
    try {
      debugPrint('🗑️ [SupabaseService] Soft deleting customer: $customerId');

      // Get current user ID for deleted_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Update customer with soft delete data
      await client.from('customers').update({
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by': userId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', customerId);

      debugPrint('✅ [SupabaseService] Customer soft deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error soft deleting customer: $e');
      throw Exception('Failed to soft delete customer: ${e.toString()}');
    }
  }

  // Suppliers
  static Future<List<Map<String, dynamic>>> getSuppliers() async {
    try {
      debugPrint('🏭 [SupabaseService] Getting suppliers...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await client
          .from('suppliers')
          .select('*')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      debugPrint('✅ [SupabaseService] Suppliers retrieved successfully');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error getting suppliers: $e');
      return [];
    }
  }

  // Create new supplier
  static Future<Map<String, dynamic>?> createSupplier(
      Map<String, dynamic> supplierData) async {
    try {
      debugPrint('➕ [SupabaseService] Creating new supplier...');

      // Get store ID
      final storeId = await getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      // Get current user ID for created_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare supplier data
      final data = {
        ...supplierData,
        'store_id': storeId,
        'created_by': userId,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📊 [SupabaseService] Supplier data: $data');

      // Insert supplier to database
      final response =
          await client.from('suppliers').insert(data).select().single();

      debugPrint('✅ [SupabaseService] Supplier created successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error creating supplier: $e');
      throw Exception('Failed to create supplier: ${e.toString()}');
    }
  }

  // Update supplier
  static Future<Map<String, dynamic>?> updateSupplier(
      String supplierId, Map<String, dynamic> supplierData) async {
    try {
      debugPrint('✏️ [SupabaseService] Updating supplier: $supplierId');

      // Get current user ID for updated_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Prepare supplier data
      final data = {
        ...supplierData,
        'updated_by': userId,
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint('📊 [SupabaseService] Supplier data: $data');

      // Update supplier in database
      final response = await client
          .from('suppliers')
          .update(data)
          .eq('id', supplierId)
          .select()
          .single();

      debugPrint('✅ [SupabaseService] Supplier updated successfully');
      return response;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error updating supplier: $e');
      throw Exception('Failed to update supplier: ${e.toString()}');
    }
  }

  // Soft delete supplier
  static Future<bool> softDeleteSupplier(String supplierId) async {
    try {
      debugPrint('🗑️ [SupabaseService] Soft deleting supplier: $supplierId');

      // Get current user ID for deleted_by
      final user = client.auth.currentUser;
      final userId = user?.id;

      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // Update supplier with soft delete data
      await client.from('suppliers').update({
        'deleted_at': DateTime.now().toIso8601String(),
        'deleted_by': userId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', supplierId);

      debugPrint('✅ [SupabaseService] Supplier soft deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ [SupabaseService] Error soft deleting supplier: $e');
      throw Exception('Failed to soft delete supplier: ${e.toString()}');
    }
  }
}
