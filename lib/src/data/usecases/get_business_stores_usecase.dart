import 'package:allnimall_store/src/core/services/business_store_service.dart';

class GetBusinessStoresUseCase {
  final BusinessStoreService _businessStoreService;

  GetBusinessStoresUseCase(this._businessStoreService);

  Future<List<Map<String, dynamic>>> execute() async {
    return await _businessStoreService.getBusinessStores();
  }
}
