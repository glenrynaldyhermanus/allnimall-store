import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:allnimall_store/src/data/objects/user.dart';

class GetStoredUserDataUseCase {
  Future<Map<String, dynamic>?> execute() async {
    try {
      final allData = await LocalStorageService.getAllStoredData();
      return allData;
    } catch (e) {
      throw Exception('Failed to get stored user data: $e');
    }
  }

  Future<AppUser?> getStoredUser() async {
    try {
      final userData = await LocalStorageService.getUserData();
      if (userData != null) {
        return AppUser.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get stored user: $e');
    }
  }

  Future<Map<String, dynamic>?> getStoredBusiness() async {
    try {
      return await LocalStorageService.getBusinessData();
    } catch (e) {
      throw Exception('Failed to get stored business data: $e');
    }
  }

  Future<Map<String, dynamic>?> getStoredStore() async {
    try {
      return await LocalStorageService.getStoreData();
    } catch (e) {
      throw Exception('Failed to get stored store data: $e');
    }
  }

  Future<Map<String, dynamic>?> getStoredRole() async {
    try {
      return await LocalStorageService.getRoleAssignmentData();
    } catch (e) {
      throw Exception('Failed to get stored role data: $e');
    }
  }

  Future<Map<String, dynamic>?> getStoredMerchant() async {
    try {
      return await LocalStorageService.getMerchantData();
    } catch (e) {
      throw Exception('Failed to get stored merchant data: $e');
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      return await LocalStorageService.isUserLoggedIn();
    } catch (e) {
      return false;
    }
  }
}
