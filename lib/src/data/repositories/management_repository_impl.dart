import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'management_repository.dart';
import 'package:flutter/foundation.dart';

class ManagementRepositoryImpl implements ManagementRepository {
  final SupabaseClient _supabaseClient;

  ManagementRepositoryImpl(this._supabaseClient);

  // Products
  @override
  Future<List<Product>> getAllProducts() async {
    try {
      debugPrint('🔄 Debug - getAllProducts started');

      final storeId = await LocalStorageService.getStoreId();
      debugPrint('🔍 Debug - Store ID: $storeId');

      if (storeId == null) {
        debugPrint('❌ Debug - Store ID not found');
        throw Exception('Store ID not found');
      }

      debugPrint('🔄 Debug - Executing Supabase query');
      // Remove the categories join since it doesn't exist
      final response = await _supabaseClient
          .from('products')
          .select('*')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      debugPrint('✅ Debug - Raw response: $response');
      debugPrint('🔍 Debug - Response type: ${response.runtimeType}');
      debugPrint('🔍 Debug - Response length: ${response.length}');

      final List<Product> products = [];
      for (final item in response) {
        try {
          debugPrint('🔍 Debug - Processing item: $item');
          final product = Product.fromJson(item);
          products.add(product);
          debugPrint('✅ Debug - Added product: ${product.name}');
        } catch (e) {
          debugPrint('❌ Debug - Failed to parse product: $e');
          debugPrint('❌ Debug - Item data: $item');
        }
      }

      debugPrint('✅ Debug - Successfully parsed ${products.length} products');
      return products;
    } catch (e, stackTrace) {
      debugPrint('❌ Debug - Error in getAllProducts: $e');
      debugPrint('🔍 Debug - Error stack trace: $stackTrace');
      throw Exception('Failed to fetch products: $e');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select('*, categories(name)')
          .eq('id', id)
          .single();

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch product');
    }
  }

  @override
  Future<void> createProduct(Map<String, dynamic> productData) async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      // Add store_id to product data
      final productDataWithStore = {
        ...productData,
        'store_id': storeId,
      };

      await _supabaseClient.from('products').insert(productDataWithStore);
    } catch (e) {
      throw Exception('Failed to create product');
    }
  }

  @override
  Future<void> updateProduct(
      String id, Map<String, dynamic> productData) async {
    try {
      await _supabaseClient.from('products').update(productData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update product');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _supabaseClient.from('products').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete product');
    }
  }

  // Categories
  @override
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await _supabaseClient
          .from('products_categories')
          .select('*, products(count)')
          .eq('store_id', storeId)
          .order('name', ascending: true);

      return (response as List)
          .map((category) {
            final products = category['products'] as List?;
            final productCount = products?.length ?? 0;

            return {
              ...category,
              'product_count': productCount,
            };
          })
          .toList()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getServiceCategories() async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await _supabaseClient
          .from('products_categories')
          .select('*, products(count)')
          .eq('store_id', storeId)
          .eq('type', 'service')
          .order('name', ascending: true);

      return (response as List)
          .map((category) {
            final products = category['products'] as List?;
            final productCount = products?.length ?? 0;

            return {
              ...category,
              'product_count': productCount,
            };
          })
          .toList()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch service categories');
    }
  }

  @override
  Future<void> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      // Add store_id to category data
      final categoryDataWithStore = {
        ...categoryData,
        'store_id': storeId,
      };

      await _supabaseClient
          .from('products_categories')
          .insert(categoryDataWithStore);
    } catch (e) {
      throw Exception('Failed to create category');
    }
  }

  @override
  Future<void> updateCategory(
      String id, Map<String, dynamic> categoryData) async {
    try {
      await _supabaseClient
          .from('products_categories')
          .update(categoryData)
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update category');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await _supabaseClient.from('products_categories').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete category');
    }
  }

  // Customers
  @override
  Future<List<Map<String, dynamic>>> getCustomers() async {
    try {
      final businessData = await LocalStorageService.getBusinessData();
      final businessId = businessData?['id'];
      if (businessId == null) {
        throw Exception('Business ID not found');
      }

      final response = await _supabaseClient
          .from('customers')
          .select('*')
          .eq('business_id', businessId)
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch customers');
    }
  }

  @override
  Future<void> createCustomer(Map<String, dynamic> customerData) async {
    try {
      final businessData = await LocalStorageService.getBusinessData();
      final businessId = businessData?['id'];
      if (businessId == null) {
        throw Exception('Business ID not found');
      }

      final customerDataWithBusiness = {
        ...customerData,
        'business_id': businessId,
      };

      await _supabaseClient.from('customers').insert(customerDataWithBusiness);
    } catch (e) {
      throw Exception('Failed to create customer');
    }
  }

  @override
  Future<void> updateCustomer(
      String id, Map<String, dynamic> customerData) async {
    try {
      await _supabaseClient.from('customers').update(customerData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update customer');
    }
  }

  @override
  Future<void> deleteCustomer(String id) async {
    try {
      await _supabaseClient.from('customers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete customer');
    }
  }

  // Suppliers
  @override
  Future<List<Map<String, dynamic>>> getSuppliers() async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await _supabaseClient
          .from('suppliers')
          .select('*')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch suppliers');
    }
  }

  @override
  Future<void> createSupplier(Map<String, dynamic> supplierData) async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final supplierDataWithStore = {
        ...supplierData,
        'store_id': storeId,
      };

      await _supabaseClient.from('suppliers').insert(supplierDataWithStore);
    } catch (e) {
      throw Exception('Failed to create supplier');
    }
  }

  @override
  Future<void> updateSupplier(
      String id, Map<String, dynamic> supplierData) async {
    try {
      await _supabaseClient.from('suppliers').update(supplierData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update supplier');
    }
  }

  @override
  Future<void> deleteSupplier(String id) async {
    try {
      await _supabaseClient.from('suppliers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete supplier');
    }
  }

  // Inventory
  @override
  Future<List<Map<String, dynamic>>> getInventory() async {
    try {
      final response = await _supabaseClient
          .from('products')
          .select('id, name, stock, min_stock, categories(name)')
          .order('name', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch inventory');
    }
  }

  @override
  Future<void> updateStock(String productId, int newStock) async {
    try {
      await _supabaseClient
          .from('products')
          .update({'stock': newStock}).eq('id', productId);
    } catch (e) {
      throw Exception('Failed to update stock');
    }
  }

  @override
  Future<void> addStock(String productId, int quantity) async {
    try {
      // Get current stock
      final response = await _supabaseClient
          .from('products')
          .select('stock')
          .eq('id', productId)
          .single();

      final currentStock = response['stock'] ?? 0;
      final newStock = currentStock + quantity;

      await _supabaseClient
          .from('products')
          .update({'stock': newStock}).eq('id', productId);
    } catch (e) {
      throw Exception('Failed to add stock');
    }
  }

  // Discounts
  @override
  Future<List<Map<String, dynamic>>> getDiscounts() async {
    try {
      final businessData = await LocalStorageService.getBusinessData();
      final businessId = businessData?['id'];
      if (businessId == null) {
        throw Exception('Business ID not found');
      }

      final response = await _supabaseClient
          .from('discounts')
          .select('*')
          .eq('business_id', businessId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch discounts');
    }
  }

  @override
  Future<void> createDiscount(Map<String, dynamic> discountData) async {
    try {
      final businessData = await LocalStorageService.getBusinessData();
      final businessId = businessData?['id'];
      if (businessId == null) {
        throw Exception('Business ID not found');
      }

      final discountDataWithBusiness = {
        ...discountData,
        'business_id': businessId,
      };

      await _supabaseClient.from('discounts').insert(discountDataWithBusiness);
    } catch (e) {
      throw Exception('Failed to create discount');
    }
  }

  @override
  Future<void> updateDiscount(
      String id, Map<String, dynamic> discountData) async {
    try {
      await _supabaseClient.from('discounts').update(discountData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update discount');
    }
  }

  @override
  Future<void> deleteDiscount(String id) async {
    try {
      await _supabaseClient.from('discounts').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete discount');
    }
  }

  @override
  Future<void> toggleDiscountStatus(String id, bool isActive) async {
    try {
      await _supabaseClient
          .from('discounts')
          .update({'is_active': isActive}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to toggle discount status');
    }
  }

  // Expenses
  @override
  Future<List<Map<String, dynamic>>> getExpenses() async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final response = await _supabaseClient
          .from('expenses')
          .select('*')
          .eq('store_id', storeId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch expenses');
    }
  }

  @override
  Future<void> createExpense(Map<String, dynamic> expenseData) async {
    try {
      final storeId = await LocalStorageService.getStoreId();
      if (storeId == null) {
        throw Exception('Store ID not found');
      }

      final expenseDataWithStore = {
        ...expenseData,
        'store_id': storeId,
      };

      await _supabaseClient.from('expenses').insert(expenseDataWithStore);
    } catch (e) {
      throw Exception('Failed to create expense');
    }
  }

  @override
  Future<void> updateExpense(
      String id, Map<String, dynamic> expenseData) async {
    try {
      await _supabaseClient.from('expenses').update(expenseData).eq('id', id);
    } catch (e) {
      throw Exception('Failed to update expense');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _supabaseClient.from('expenses').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete expense');
    }
  }

  @override
  Future<void> markExpenseAsPaid(String id) async {
    try {
      await _supabaseClient.from('expenses').update({
        'is_paid': true,
        'paid_at': DateTime.now().toIso8601String()
      }).eq('id', id);
    } catch (e) {
      throw Exception('Failed to mark expense as paid');
    }
  }

  // Loyalty Programs
  @override
  Future<List<Map<String, dynamic>>> getLoyaltyPrograms() async {
    try {
      final businessData = await LocalStorageService.getBusinessData();
      final businessId = businessData?['id'];
      if (businessId == null) {
        throw Exception('Business ID not found');
      }

      final response = await _supabaseClient
          .from('loyalty_programs')
          .select('*, customer_loyalty_memberships(count)')
          .eq('business_id', businessId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((program) {
            final memberships =
                program['customer_loyalty_memberships'] as List?;
            final memberCount = memberships?.length ?? 0;

            return {
              ...program,
              'members': memberCount,
            };
          })
          .toList()
          .cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch loyalty programs');
    }
  }

  @override
  Future<void> createLoyaltyProgram(Map<String, dynamic> programData) async {
    try {
      final businessData = await LocalStorageService.getBusinessData();
      final businessId = businessData?['id'];
      if (businessId == null) {
        throw Exception('Business ID not found');
      }

      final programDataWithBusiness = {
        ...programData,
        'business_id': businessId,
      };

      await _supabaseClient
          .from('loyalty_programs')
          .insert(programDataWithBusiness);
    } catch (e) {
      throw Exception('Failed to create loyalty program');
    }
  }

  @override
  Future<void> updateLoyaltyProgram(
      String id, Map<String, dynamic> programData) async {
    try {
      await _supabaseClient
          .from('loyalty_programs')
          .update(programData)
          .eq('id', id);
    } catch (e) {
      throw Exception('Failed to update loyalty program');
    }
  }

  @override
  Future<void> deleteLoyaltyProgram(String id) async {
    try {
      await _supabaseClient.from('loyalty_programs').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete loyalty program');
    }
  }

  @override
  Future<void> toggleLoyaltyProgramStatus(String id, bool isActive) async {
    try {
      await _supabaseClient
          .from('loyalty_programs')
          .update({'is_active': isActive}).eq('id', id);
    } catch (e) {
      throw Exception('Failed to toggle loyalty program status');
    }
  }
}
