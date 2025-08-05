import 'package:allnimall_store/src/data/repositories/management_repository.dart';

class GetServiceCategoriesUseCase {
  final ManagementRepository _managementRepository;

  GetServiceCategoriesUseCase(this._managementRepository);

  Future<List<Map<String, dynamic>>> execute() async {
    return await _managementRepository.getServiceCategories();
  }
}
