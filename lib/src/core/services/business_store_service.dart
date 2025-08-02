import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';

class BusinessStoreService {
  final SupabaseClient _supabaseClient;

  BusinessStoreService(this._supabaseClient);

  /// Get user's business and store data after successful login
  Future<Map<String, dynamic>> getUserBusinessAndStore() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('🔍 Checking role assignments for user: ${user.id}');
      debugPrint('👤 User email: ${user.email}');
      debugPrint('👤 User metadata: ${user.userMetadata}');

      // First, get the user from our users table using auth_id
      final userResponse = await _supabaseClient
          .from('users')
          .select('id, name, email, username, auth_id')
          .eq('auth_id', user.id)
          .eq('is_active', true)
          .single();

      final userId = userResponse['id'];
      debugPrint('👤 Found user in database: $userId');

      // Now check role assignments using the user ID from our users table
      final roleAssignmentsCheck = await _supabaseClient
          .from('role_assignments')
          .select('id, user_id, merchant_id, store_id, role_id, is_active')
          .eq('user_id', userId)
          .eq('is_active', true);

      debugPrint('📊 Found ${roleAssignmentsCheck.length} role assignments');

      if (roleAssignmentsCheck.isEmpty) {
        // Let's also check if there are any role assignments for this user (active or inactive)
        final allRoleAssignments = await _supabaseClient
            .from('role_assignments')
            .select('id, user_id, merchant_id, store_id, role_id, is_active')
            .eq('user_id', userId);

        debugPrint(
            '📊 Total role assignments for user (active + inactive): ${allRoleAssignments.length}');

        if (allRoleAssignments.isNotEmpty) {
          debugPrint('⚠️ User has role assignments but none are active');
          debugPrint('📋 Role assignments: $allRoleAssignments');
        }

        throw Exception('User tidak memiliki role assignment');
      }

      // Get user's role assignments with merchant and store info
      final roleAssignmentsResponse =
          await _supabaseClient.from('role_assignments').select('''
            *,
            merchant:merchants(*),
            store:stores(*),
            role:roles(*)
          ''').eq('user_id', userId).eq('is_active', true);

      debugPrint(
          '📊 Role assignments response: ${roleAssignmentsResponse.length} items');

      if (roleAssignmentsResponse.isEmpty) {
        throw Exception('User tidak memiliki role assignment aktif');
      }

      // Get the first role assignment (assuming one user has one role)
      final roleAssignment = roleAssignmentsResponse.first;
      debugPrint('📋 Role assignment data: $roleAssignment');

      final merchantData = roleAssignment['merchant'];
      final storeData = roleAssignment['store'];
      final roleData = roleAssignment['role'];

      debugPrint('🏪 Merchant data: $merchantData');
      debugPrint('🏬 Store data: $storeData');
      debugPrint('👤 Role data: $roleData');

      // Validate merchant data
      if (merchantData == null) {
        throw Exception('User tidak terhubung dengan merchant');
      }

      // Validate store data
      if (storeData == null) {
        throw Exception('User tidak terhubung dengan toko');
      }

      // Validate role data
      if (roleData == null) {
        throw Exception('User tidak memiliki role');
      }

      // Save to local storage
      await LocalStorageService.saveBusinessData(merchantData);
      await LocalStorageService.saveStoreData(storeData);
      await LocalStorageService.saveRoleAssignmentData(roleAssignment);

      // Also save as merchant data (alias for business)
      await LocalStorageService.saveMerchantData(merchantData);

      debugPrint('✅ Business and store data loaded successfully');

      return {
        'business': merchantData,
        'store': storeData,
        'role': roleData,
        'roleAssignment': roleAssignment,
      };
    } catch (e) {
      debugPrint('❌ Error in getUserBusinessAndStore: $e');
      throw Exception(
          'Failed to get user business and store data: ${e.toString()}');
    }
  }

  /// Get current store ID from local storage
  Future<String?> getCurrentStoreId() async {
    return await LocalStorageService.getStoreId();
  }

  /// Get current business ID from local storage
  Future<String?> getCurrentBusinessId() async {
    final businessData = await LocalStorageService.getBusinessData();
    return businessData?['id'];
  }

  /// Check if user has valid business and store data
  Future<bool> hasValidBusinessAndStore() async {
    final storeId = await getCurrentStoreId();
    final businessId = await getCurrentBusinessId();
    return storeId != null && businessId != null;
  }

  /// Get all stores for current business
  Future<List<Map<String, dynamic>>> getBusinessStores() async {
    try {
      final businessId = await getCurrentBusinessId();
      if (businessId == null) {
        throw Exception('No business ID found');
      }

      final response = await _supabaseClient
          .from('stores')
          .select('*')
          .eq('business_id', businessId)
          .order('name', ascending: true);

      return (response as List).cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to get business stores');
    }
  }

  /// Switch to different store
  Future<void> switchStore(String storeId) async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // First, get the user from our users table using auth_id
      final userResponse = await _supabaseClient
          .from('users')
          .select('id')
          .eq('auth_id', user.id)
          .eq('is_active', true)
          .single();

      final userId = userResponse['id'];

      // Get role assignment for this store using user ID from our users table
      final roleAssignmentResponse =
          await _supabaseClient.from('role_assignments').select('''
            *,
            merchant:merchants(*),
            store:stores(*),
            role:roles(*)
          ''').eq('user_id', userId).eq('store_id', storeId).eq('is_active', true).single();

      // Save new store data
      await LocalStorageService.saveStoreData(roleAssignmentResponse['store']);
      await LocalStorageService.saveRoleAssignmentData(roleAssignmentResponse);
    } catch (e) {
      throw Exception('Failed to switch store');
    }
  }
}
