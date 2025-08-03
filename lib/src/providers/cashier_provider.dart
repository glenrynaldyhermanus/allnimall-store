import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:allnimall_store/src/core/config/app_config.dart';
import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/usecases/add_to_cart_usecase.dart';
import 'package:allnimall_store/src/data/usecases/clear_cart_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_cart_usecase.dart';
import 'package:allnimall_store/src/data/usecases/get_products_usecase.dart';
import 'package:allnimall_store/src/data/usecases/update_cart_quantity_usecase.dart';
import 'package:allnimall_store/src/data/repositories/pos_repository_impl.dart';

import 'auth_provider.dart';

// Cashier State
abstract class CashierState {
  const CashierState();
}

class CashierInitial extends CashierState {}

class CashierLoading extends CashierState {}

class CashierLoaded extends CashierState {
  final List<Product> products;
  final List<CartItem> cartItems;
  final String searchTerm;
  final String selectedCategory;
  final double total;
  final double tax;
  final double discount;
  final double finalTotal;

  const CashierLoaded({
    required this.products,
    required this.cartItems,
    this.searchTerm = '',
    this.selectedCategory = 'all',
    required this.total,
    required this.tax,
    required this.discount,
    required this.finalTotal,
  });

  CashierLoaded copyWith({
    List<Product>? products,
    List<CartItem>? cartItems,
    String? searchTerm,
    String? selectedCategory,
    double? total,
    double? tax,
    double? discount,
    double? finalTotal,
  }) {
    return CashierLoaded(
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      searchTerm: searchTerm ?? this.searchTerm,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      finalTotal: finalTotal ?? this.finalTotal,
    );
  }
}

class CashierError extends CashierState {
  final String message;

  const CashierError(this.message);
}

// Repository Providers
final posRepositoryProvider = Provider<PosRepositoryImpl>((ref) {
  final supabaseClient = ref.read(supabaseClientProvider);
  return PosRepositoryImpl(supabaseClient);
});

// UseCase Providers
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final posRepository = ref.read(posRepositoryProvider);
  return GetProductsUseCase(posRepository);
});

final getCartUseCaseProvider = Provider<GetCartUseCase>((ref) {
  final posRepository = ref.read(posRepositoryProvider);
  return GetCartUseCase(posRepository);
});

final addToCartUseCaseProvider = Provider<AddToCartUseCase>((ref) {
  final posRepository = ref.read(posRepositoryProvider);
  return AddToCartUseCase(posRepository);
});

final updateCartQuantityUseCaseProvider =
    Provider<UpdateCartQuantityUseCase>((ref) {
  final posRepository = ref.read(posRepositoryProvider);
  return UpdateCartQuantityUseCase(posRepository);
});

final clearCartUseCaseProvider = Provider<ClearCartUseCase>((ref) {
  final posRepository = ref.read(posRepositoryProvider);
  return ClearCartUseCase(posRepository);
});

// Cashier Notifier
class CashierNotifier extends StateNotifier<CashierState> {
  final Ref ref;

  CashierNotifier(this.ref) : super(CashierInitial());

  Future<void> loadProducts() async {
    debugPrint('🔄 [CashierProvider] Starting loadProducts...');
    state = CashierLoading();
    try {
      final getProductsUseCase = ref.read(getProductsUseCaseProvider);
      final getCartUseCase = ref.read(getCartUseCaseProvider);

      debugPrint('🔄 [CashierProvider] Loading products...');
      final products = await getProductsUseCase();
      debugPrint(
          '🔄 [CashierProvider] Products loaded: ${products.length} items');

      debugPrint('🛒 [CashierProvider] Loading cart...');
      final cartItems = await getCartUseCase();
      debugPrint('🛒 [CashierProvider] Cart loaded: ${cartItems.length} items');

      final sortedCartItems = _sortCartItems(cartItems);
      final totals = _calculateTotals(sortedCartItems);

      debugPrint('✅ [CashierProvider] Setting CashierLoaded state...');
      state = CashierLoaded(
        products: products,
        cartItems: sortedCartItems,
        total: totals['total']!,
        tax: totals['tax']!,
        discount: totals['discount']!,
        finalTotal: totals['finalTotal']!,
      );
      debugPrint('✅ [CashierProvider] State updated successfully');
    } catch (e) {
      debugPrint('❌ [CashierProvider] Error in loadProducts: $e');
      state = CashierError(e.toString());
    }
  }

  Future<void> loadCart() async {
    debugPrint('🛒 [CashierProvider] Starting loadCart...');
    try {
      // If state is initial, load products first
      if (state is CashierInitial) {
        debugPrint(
            '🔄 [CashierProvider] State is initial, loading products first...');
        await loadProducts();
        return;
      }

      if (state is CashierLoaded) {
        debugPrint('🔄 [CashierProvider] State is loaded, updating cart...');
        final currentState = state as CashierLoaded;
        try {
          final getCartUseCase = ref.read(getCartUseCaseProvider);
          debugPrint('🛒 [CashierProvider] Loading cart items...');
          final cartItems = await getCartUseCase();
          debugPrint(
              '🛒 [CashierProvider] Cart items loaded: ${cartItems.length} items');

          final sortedCartItems = _sortCartItems(cartItems);
          final totals = _calculateTotals(sortedCartItems);

          debugPrint(
              '✅ [CashierProvider] Updating state with new cart data...');
          state = currentState.copyWith(
            cartItems: sortedCartItems,
            total: totals['total']!,
            tax: totals['tax']!,
            discount: totals['discount']!,
            finalTotal: totals['finalTotal']!,
          );
          debugPrint('✅ [CashierProvider] State updated successfully');
        } catch (e) {
          debugPrint('❌ [CashierProvider] Error updating cart: $e');
          state = CashierError(e.toString());
        }
      } else {
        debugPrint(
            '🔄 [CashierProvider] State is not loaded, loading products first...');
        // If state is not loaded, load products first
        await loadProducts();
      }
    } catch (e) {
      debugPrint('❌ [CashierProvider] Error in loadCart: $e');
      state = CashierError(e.toString());
    }
  }

  Future<void> addToCart(String productId, int quantity) async {
    debugPrint(
        '🛒 [CashierProvider] addToCart called with productId: $productId, quantity: $quantity');

    if (state is CashierLoaded) {
      final currentState = state as CashierLoaded;
      try {
        final addToCartUseCase = ref.read(addToCartUseCaseProvider);
        final getCartUseCase = ref.read(getCartUseCaseProvider);

        debugPrint('🛒 [CashierProvider] Calling addToCartUseCase...');
        await addToCartUseCase(productId, quantity);
        debugPrint('🛒 [CashierProvider] Product added to cart successfully');

        debugPrint('🛒 [CashierProvider] Loading updated cart...');
        final cartItems = await getCartUseCase();
        debugPrint(
            '🛒 [CashierProvider] Cart loaded with ${cartItems.length} items');

        final sortedCartItems = _sortCartItems(cartItems);
        final totals = _calculateTotals(sortedCartItems);

        debugPrint('✅ [CashierProvider] Updating state with new cart data...');
        state = currentState.copyWith(
          cartItems: sortedCartItems,
          total: totals['total']!,
          tax: totals['tax']!,
          discount: totals['discount']!,
          finalTotal: totals['finalTotal']!,
        );
        debugPrint('✅ [CashierProvider] State updated successfully');
      } catch (e) {
        debugPrint('❌ [CashierProvider] Error in addToCart: $e');
        state = CashierError(e.toString());
      }
    } else {
      debugPrint(
          '❌ [CashierProvider] State is not CashierLoaded, current state: ${state.runtimeType}');
    }
  }

  Future<void> updateCartQuantity(String productId, int quantity) async {
    if (state is CashierLoaded) {
      final currentState = state as CashierLoaded;
      try {
        final updateCartQuantityUseCase =
            ref.read(updateCartQuantityUseCaseProvider);
        final getCartUseCase = ref.read(getCartUseCaseProvider);

        await updateCartQuantityUseCase(productId, quantity);
        final cartItems = await getCartUseCase();
        final sortedCartItems = _sortCartItems(cartItems);
        final totals = _calculateTotals(sortedCartItems);

        state = currentState.copyWith(
          cartItems: sortedCartItems,
          total: totals['total']!,
          tax: totals['tax']!,
          discount: totals['discount']!,
          finalTotal: totals['finalTotal']!,
        );
      } catch (e) {
        state = CashierError(e.toString());
      }
    }
  }

  Future<void> clearCart() async {
    if (state is CashierLoaded) {
      final currentState = state as CashierLoaded;
      try {
        final clearCartUseCase = ref.read(clearCartUseCaseProvider);
        final getCartUseCase = ref.read(getCartUseCaseProvider);

        await clearCartUseCase();
        final cartItems = await getCartUseCase();
        final sortedCartItems = _sortCartItems(cartItems);
        final totals = _calculateTotals(sortedCartItems);

        state = currentState.copyWith(
          cartItems: sortedCartItems,
          total: totals['total']!,
          tax: totals['tax']!,
          discount: totals['discount']!,
          finalTotal: totals['finalTotal']!,
        );
      } catch (e) {
        state = CashierError(e.toString());
      }
    }
  }

  void searchProducts(String searchTerm) {
    if (state is CashierLoaded) {
      final currentState = state as CashierLoaded;
      state = currentState.copyWith(searchTerm: searchTerm);
    }
  }

  void filterByCategory(String category) {
    if (state is CashierLoaded) {
      final currentState = state as CashierLoaded;
      state = currentState.copyWith(selectedCategory: category);
    }
  }

  List<CartItem> _sortCartItems(List<CartItem> cartItems) {
    cartItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return cartItems;
  }

  Map<String, double> _calculateTotals(List<CartItem> cartItems) {
    final total = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = total * AppConfig.taxRate;
    const discount = 0.0;
    final finalTotal = total + tax - discount;

    return {
      'total': total,
      'tax': tax,
      'discount': discount,
      'finalTotal': finalTotal,
    };
  }
}

// Cashier Provider
final cashierProvider =
    StateNotifierProvider<CashierNotifier, CashierState>((ref) {
  return CashierNotifier(ref);
});
