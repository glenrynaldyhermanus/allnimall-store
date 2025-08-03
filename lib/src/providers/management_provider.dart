import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/usecases/get_all_products_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_categories_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_customers_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_suppliers_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_discounts_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_expenses_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_loyalty_programs_usecase.dart';
import 'package:allnimall_store/src/data/usecases/delete_product_usecase.dart';
import 'package:allnimall_store/src/data/repositories/management_repository_impl.dart';

import 'auth_provider.dart';

// Management State
abstract class ManagementState {
  const ManagementState();
}

class ManagementInitial extends ManagementState {}

class ManagementLoading extends ManagementState {}

class ManagementError extends ManagementState {
  final String message;

  const ManagementError(this.message);
}

class ProductsLoaded extends ManagementState {
  final List<Product> products;

  const ProductsLoaded(this.products);
}

class CategoriesLoaded extends ManagementState {
  final List<Map<String, dynamic>> categories;

  const CategoriesLoaded(this.categories);
}

class CustomersLoaded extends ManagementState {
  final List<Map<String, dynamic>> customers;

  const CustomersLoaded(this.customers);
}

class SuppliersLoaded extends ManagementState {
  final List<Map<String, dynamic>> suppliers;

  const SuppliersLoaded(this.suppliers);
}

class InventoryLoaded extends ManagementState {
  final List<Product> inventory;

  const InventoryLoaded(this.inventory);
}

class DiscountsLoaded extends ManagementState {
  final List<Map<String, dynamic>> discounts;

  const DiscountsLoaded(this.discounts);
}

class ExpensesLoaded extends ManagementState {
  final List<Map<String, dynamic>> expenses;

  const ExpensesLoaded(this.expenses);
}

class LoyaltyProgramsLoaded extends ManagementState {
  final List<Map<String, dynamic>> programs;

  const LoyaltyProgramsLoaded(this.programs);
}

// Repository Providers
final managementRepositoryProvider = Provider<ManagementRepositoryImpl>((ref) {
  final supabaseClient = ref.read(supabaseClientProvider);
  return ManagementRepositoryImpl(supabaseClient);
});

// UseCase Providers
final getAllProductsUseCaseProvider = Provider<GetAllProductsUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetAllProductsUseCase(managementRepository);
});

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetCategoriesUseCase(managementRepository);
});

final getCustomersUseCaseProvider = Provider<GetCustomersUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetCustomersUseCase(managementRepository);
});

final getSuppliersUseCaseProvider = Provider<GetSuppliersUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetSuppliersUseCase(managementRepository);
});

final getDiscountsUseCaseProvider = Provider<GetDiscountsUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetDiscountsUseCase(managementRepository);
});

final getExpensesUseCaseProvider = Provider<GetExpensesUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetExpensesUseCase(managementRepository);
});

final getLoyaltyProgramsUseCaseProvider =
    Provider<GetLoyaltyProgramsUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return GetLoyaltyProgramsUseCase(managementRepository);
});

final deleteProductUseCaseProvider = Provider<DeleteProductUseCase>((ref) {
  final managementRepository = ref.read(managementRepositoryProvider);
  return DeleteProductUseCase(managementRepository);
});

// Management Notifier
class ManagementNotifier extends StateNotifier<ManagementState> {
  final Ref ref;

  ManagementNotifier(this.ref) : super(ManagementInitial());

  Future<void> loadProducts() async {
    state = ManagementLoading();
    try {
      final getAllProductsUseCase = ref.read(getAllProductsUseCaseProvider);
      final products = await getAllProductsUseCase.execute();
      state = ProductsLoaded(products);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadCategories() async {
    state = ManagementLoading();
    try {
      final getCategoriesUseCase = ref.read(getCategoriesUseCaseProvider);
      final categories = await getCategoriesUseCase.execute();
      state = CategoriesLoaded(categories);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadCustomers() async {
    state = ManagementLoading();
    try {
      final getCustomersUseCase = ref.read(getCustomersUseCaseProvider);
      final customers = await getCustomersUseCase.execute();
      state = CustomersLoaded(customers);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadSuppliers() async {
    state = ManagementLoading();
    try {
      final getSuppliersUseCase = ref.read(getSuppliersUseCaseProvider);
      final suppliers = await getSuppliersUseCase.execute();
      state = SuppliersLoaded(suppliers);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadInventory() async {
    state = ManagementLoading();
    try {
      final getAllProductsUseCase = ref.read(getAllProductsUseCaseProvider);
      final inventory = await getAllProductsUseCase.execute();
      state = InventoryLoaded(inventory);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadDiscounts() async {
    state = ManagementLoading();
    try {
      final getDiscountsUseCase = ref.read(getDiscountsUseCaseProvider);
      final discounts = await getDiscountsUseCase.execute();
      state = DiscountsLoaded(discounts);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadExpenses() async {
    state = ManagementLoading();
    try {
      final getExpensesUseCase = ref.read(getExpensesUseCaseProvider);
      final expenses = await getExpensesUseCase.execute();
      state = ExpensesLoaded(expenses);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> loadLoyaltyPrograms() async {
    state = ManagementLoading();
    try {
      final getLoyaltyProgramsUseCase =
          ref.read(getLoyaltyProgramsUseCaseProvider);
      final programs = await getLoyaltyProgramsUseCase.execute();
      state = LoyaltyProgramsLoaded(programs);
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  // TODO: Implement CRUD operations for all entities
  Future<void> updateProduct(Product product) async {
    try {
      // TODO: Implement update product usecase
      await loadProducts();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      // TODO: Implement create product usecase
      await loadProducts();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final deleteProductUseCase = ref.read(deleteProductUseCaseProvider);
      await deleteProductUseCase.execute(productId);
      await loadProducts(); // Reload products after deletion
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createCategory(Map<String, dynamic> category) async {
    try {
      // TODO: Implement create category usecase
      await loadCategories();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> updateCategory(
      String categoryId, Map<String, dynamic> category) async {
    try {
      // TODO: Implement update category usecase
      await loadCategories();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      // TODO: Implement delete category usecase
      await loadCategories();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createCustomer(Map<String, dynamic> customer) async {
    try {
      // TODO: Implement create customer usecase
      await loadCustomers();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> updateCustomer(
      String customerId, Map<String, dynamic> customer) async {
    try {
      // TODO: Implement update customer usecase
      await loadCustomers();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      // TODO: Implement delete customer usecase
      await loadCustomers();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createSupplier(Map<String, dynamic> supplier) async {
    try {
      // TODO: Implement create supplier usecase
      await loadSuppliers();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> updateSupplier(
      String supplierId, Map<String, dynamic> supplier) async {
    try {
      // TODO: Implement update supplier usecase
      await loadSuppliers();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      // TODO: Implement delete supplier usecase
      await loadSuppliers();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createDiscount(Map<String, dynamic> discount) async {
    try {
      // TODO: Implement create discount usecase
      await loadDiscounts();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> updateDiscount(
      String discountId, Map<String, dynamic> discount) async {
    try {
      // TODO: Implement update discount usecase
      await loadDiscounts();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteDiscount(String discountId) async {
    try {
      // TODO: Implement delete discount usecase
      await loadDiscounts();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> toggleDiscountStatus(String discountId) async {
    try {
      // TODO: Implement toggle discount status usecase
      await loadDiscounts();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createExpense(Map<String, dynamic> expense) async {
    try {
      // TODO: Implement create expense usecase
      await loadExpenses();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> updateExpense(
      String expenseId, Map<String, dynamic> expense) async {
    try {
      // TODO: Implement update expense usecase
      await loadExpenses();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      // TODO: Implement delete expense usecase
      await loadExpenses();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> markExpenseAsPaid(String expenseId) async {
    try {
      // TODO: Implement mark expense as paid usecase
      await loadExpenses();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> createLoyaltyProgram(Map<String, dynamic> program) async {
    try {
      // TODO: Implement create loyalty program usecase
      await loadLoyaltyPrograms();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> updateLoyaltyProgram(
      String programId, Map<String, dynamic> program) async {
    try {
      // TODO: Implement update loyalty program usecase
      await loadLoyaltyPrograms();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> deleteLoyaltyProgram(String programId) async {
    try {
      // TODO: Implement delete loyalty program usecase
      await loadLoyaltyPrograms();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }

  Future<void> toggleLoyaltyProgramStatus(String programId) async {
    try {
      // TODO: Implement toggle loyalty program status usecase
      await loadLoyaltyPrograms();
    } catch (e) {
      state = ManagementError(e.toString());
    }
  }
}

// Management Provider
final managementProvider =
    StateNotifierProvider<ManagementNotifier, ManagementState>((ref) {
  return ManagementNotifier(ref);
});
