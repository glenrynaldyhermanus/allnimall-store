import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/guards/auth_guard.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:allnimall_store/src/data/objects/product.dart';
import 'package:allnimall_store/src/data/objects/cart_item.dart';
import 'package:allnimall_store/src/data/usecases/get_all_products_usecase.dart';
import 'package:allnimall_store/src/core/services/local_storage_service.dart';
import 'package:allnimall_store/src/data/repositories/management_repository_impl.dart';
import 'package:allnimall_store/src/core/services/supabase_service.dart';
import 'package:allnimall_store/src/core/services/business_store_service.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';
import 'package:allnimall_store/src/widgets/ui/feedback/product_loading.dart';
import 'package:allnimall_store/src/widgets/ui/feedback/cart_loading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:allnimall_store/src/providers/auth_provider.dart';
import 'package:allnimall_store/src/data/objects/user.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_text_input.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_select.dart';

class CashierPage extends ConsumerStatefulWidget {
  const CashierPage({super.key});

  @override
  ConsumerState<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends ConsumerState<CashierPage> {
  // Header State
  String? storeName = 'Store';
  String? businessName = 'Merchant';
  String? userName = 'Kasir';
  bool isHeaderLoaded = false;

  // Products State
  List<Product> products = [];
  List<Product> filteredProducts = [];
  bool isLoadingProducts = true;

  // Search and Filter State
  final TextEditingController _searchController = TextEditingController();
  String? selectedCategory;
  List<String> categories = [];

  // Cart State
  List<CartItem> cartItems = [];
  bool isLoadingCart = false;

  // Loading State
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Load header data
    _loadHeaderData().catchError((e) {
      debugPrint('Error loading header data: $e');
    });

    // Load products data with delay to avoid conflicts
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _loadProductsData().catchError((e) {
          debugPrint('Error loading products data: $e');
        });
      }
    });

    // Add search listener
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    debugPrint('🔄 Debug - dispose called');
    super.dispose();
  }

  void _filterProducts() {
    final searchQuery = _searchController.text.toLowerCase();

    setState(() {
      filteredProducts = products.where((product) {
        final matchesSearch =
            product.name.toLowerCase().contains(searchQuery) ||
                (product.code?.toLowerCase().contains(searchQuery) ?? false) ||
                (product.barcode?.toLowerCase().contains(searchQuery) ?? false);

        final matchesCategory = selectedCategory == null ||
            product.categoryName == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onCategoryChanged(String? category) {
    setState(() {
      selectedCategory = category;
    });
    _filterProducts();
  }

  // Method to get user data from auth provider
  Future<Map<String, dynamic>?> _getUserDataFromAuthProvider() async {
    try {
      final AuthNotifier authNotifier = ref.read(authProvider.notifier);
      final Map<String, dynamic>? userData =
          await authNotifier.getStoredUserData();
      debugPrint('🔍 Debug - User data from auth provider: $userData');
      return userData;
    } catch (e) {
      debugPrint('❌ Debug - Failed to get user data from auth provider: $e');
      return null;
    }
  }

  // Method to get current user object
  Future<AppUser?> _getCurrentUserObject() async {
    try {
      final AuthNotifier authNotifier = ref.read(authProvider.notifier);
      final Map<String, dynamic>? userData =
          await authNotifier.getStoredUserData();
      if (userData != null) {
        final AppUser user = AppUser.fromJson(userData);
        debugPrint('🔍 Debug - Current user object: $user');
        return user;
      }
      return null;
    } catch (e) {
      debugPrint('❌ Debug - Failed to get current user object: $e');
      return null;
    }
  }

  Future<void> _loadHeaderData() async {
    debugPrint('🔄 Debug - _loadHeaderData started');

    try {
      // Try to get user data from auth provider first
      var userData = await _getUserDataFromAuthProvider();
      var currentUserObject = await _getCurrentUserObject();

      // Load business and store data
      var businessData = await LocalStorageService.getBusinessData();
      var storeData = await LocalStorageService.getStoreData();

      // If no user data from auth provider, try local storage
      if (userData == null) {
        debugPrint(
            '🔄 Debug - No user data from auth provider, trying local storage...');
        userData = await LocalStorageService.getUserData();
      }

      // Always try to get fresh user data from server
      debugPrint(
          '🔄 Debug - Always trying to get fresh user data from server...');
      try {
        final currentUser = SupabaseService.client.auth.currentUser;
        if (currentUser != null) {
          debugPrint('🔄 Debug - Current user ID: ${currentUser.id}');
          final userResponse = await SupabaseService.client
              .from('users')
              .select()
              .eq('id', currentUser.id)
              .single();
          userData = userResponse;
          debugPrint('✅ Got fresh user data from server: $userData');
          debugPrint('✅ User name from server: ${userData['name']}');

          // Save the fresh user data to local storage
          try {
            await LocalStorageService.saveUserData(userData);
            debugPrint('✅ Saved fresh user data to local storage');
          } catch (saveError) {
            debugPrint(
                '❌ Failed to save user data to local storage: $saveError');
          }
        } else {
          debugPrint('❌ No current user found');
        }
      } catch (userError) {
        debugPrint('❌ Failed to get user data from server: $userError');
      }

      // Debug: Print loaded data
      debugPrint('🔍 Debug - User Data: $userData');
      debugPrint('🔍 Debug - Current User Object: $currentUserObject');
      debugPrint('🔍 Debug - User Data type: ${userData.runtimeType}');
      debugPrint('🔍 Debug - User Data keys: ${userData?.keys}');
      debugPrint('🔍 Debug - User Data name field: ${userData?['name']}');
      debugPrint(
          '🔍 Debug - User Data name field type: ${userData?['name'].runtimeType}');
      debugPrint('🔍 Debug - User Data is null: ${userData == null}');
      debugPrint('🔍 Debug - User Data is empty: ${userData?.isEmpty}');
      debugPrint('🔍 Debug - Business Data: $businessData');
      debugPrint('🔍 Debug - Store Data: $storeData');
      debugPrint('🔍 Debug - Store Data name: ${storeData?['name']}');
      debugPrint('🔍 Debug - Business Data name: ${businessData?['name']}');
      debugPrint('🔍 Debug - User Data name: ${userData?['name']}');
      debugPrint('🔍 Debug - User Data id: ${userData?['id']}');
      debugPrint('🔍 Debug - User Data phone: ${userData?['phone']}');
      debugPrint('🔍 Debug - Data loading completed');

      // Fallback: If business/store data is not available, try to get from role assignment
      if (businessData == null || storeData == null) {
        debugPrint(
            '⚠️ Business or store data not found, trying role assignment...');
        final roleAssignmentData =
            await LocalStorageService.getRoleAssignmentData();
        debugPrint('🔍 Debug - Role Assignment Data: $roleAssignmentData');

        if (roleAssignmentData != null) {
          if (businessData == null && roleAssignmentData['merchant'] != null) {
            businessData = roleAssignmentData['merchant'];
            debugPrint('✅ Using merchant data from role assignment');
          }
          if (storeData == null && roleAssignmentData['store'] != null) {
            storeData = roleAssignmentData['store'];
            debugPrint('✅ Using store data from role assignment');
          }
        }
      }

      // If still no data, try to reload from server
      if (businessData == null || storeData == null || userData == null) {
        debugPrint(
            '⚠️ Still no business/store/user data, attempting to reload from server...');
        try {
          final businessStoreService =
              BusinessStoreService(SupabaseService.client);
          final freshData =
              await businessStoreService.getUserBusinessAndStore();
          businessData = freshData['business'];
          storeData = freshData['store'];

          // Also try to get fresh user data
          if (userData == null || userData['name'] == null) {
            try {
              final currentUser = SupabaseService.client.auth.currentUser;
              if (currentUser != null) {
                final userResponse = await SupabaseService.client
                    .from('users')
                    .select()
                    .eq('id', currentUser.id)
                    .single();
                userData = userResponse;
                debugPrint('✅ Successfully reloaded user data from server');
                debugPrint('🔍 Debug - Fresh user data: $userData');
              }
            } catch (userError) {
              debugPrint(
                  '❌ Failed to reload user data from server: $userError');
            }
          }

          debugPrint('✅ Successfully reloaded data from server');
        } catch (e) {
          debugPrint('❌ Failed to reload data from server: $e');
        }
      }

      // Update header data first
      debugPrint('🔄 Debug - About to update header data');
      debugPrint(
          '🔄 Debug - Before setState - isHeaderLoaded: $isHeaderLoaded');
      debugPrint('🔄 Debug - storeData: $storeData');
      debugPrint('🔄 Debug - businessData: $businessData');
      debugPrint('🔄 Debug - userData: $userData');
      debugPrint('🔄 Debug - userData type: ${userData.runtimeType}');
      debugPrint('🔄 Debug - userData keys: ${userData?.keys}');
      debugPrint('🔄 Debug - userData name field: ${userData?['name']}');
      debugPrint(
          '🔄 Debug - userData name field type: ${userData?['name'].runtimeType}');

      // Force immediate state update
      setState(() {
        debugPrint('🔄 Debug - Inside setState for header');

        // Update with actual data
        storeName = storeData?['name'] ?? 'Toko';
        businessName = businessData?['name'] ?? 'Allnimall Pet Shop';

        // Improved user name logic with better fallback
        String? userNameFromData;

        // Handle nested userData structure
        if (userData != null && userData['user'] != null) {
          userNameFromData = userData['user']['name'];
          debugPrint(
              '🔄 Debug - userNameFromData from nested structure: $userNameFromData');
        } else {
          userNameFromData = userData?['name'];
          debugPrint(
              '🔄 Debug - userNameFromData from flat structure: $userNameFromData');
        }

        if (userNameFromData != null && userNameFromData.isNotEmpty) {
          userName = userNameFromData;
          debugPrint('🔄 Debug - Using userName from data: $userName');
        } else if (currentUserObject != null &&
            currentUserObject.name.isNotEmpty) {
          // Use AppUser object if available
          userName = currentUserObject.name;
          debugPrint(
              '🔄 Debug - Using userName from AppUser object: $userName');
        } else {
          // Try to get username as fallback
          String? usernameFromData;
          if (userData != null && userData['user'] != null) {
            usernameFromData = userData['user']['username'];
          } else {
            usernameFromData = userData?['username'];
          }
          debugPrint('🔄 Debug - usernameFromData: $usernameFromData');

          if (usernameFromData != null && usernameFromData.isNotEmpty) {
            userName = usernameFromData;
            debugPrint('🔄 Debug - Using username as fallback: $userName');
          } else {
            // Final fallback - get from current user email
            try {
              final currentUser = SupabaseService.client.auth.currentUser;
              if (currentUser != null && currentUser.email != null) {
                // Extract name from email (before @)
                String emailName = currentUser.email!.split('@')[0];
                userName = emailName.isNotEmpty ? emailName : 'User';
                debugPrint(
                    '🔄 Debug - Using email name as fallback: $userName');
              } else {
                userName = 'User';
                debugPrint('🔄 Debug - Using default fallback: $userName');
              }
            } catch (e) {
              userName = 'User';
              debugPrint(
                  '🔄 Debug - Using default fallback due to error: $userName');
            }
          }
        }

        // Force set to true
        isHeaderLoaded = true;
      });

      // Only add post frame callback if widget is still mounted
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {});
          }
        });
      }
    } catch (e) {
      // Set header loaded even if there's an error
      setState(() {
        isHeaderLoaded = true;
      });
    }
  }

  Future<void> _loadProductsData() async {
    debugPrint('🔄 Debug - _loadProductsData started');

    if (!mounted) {
      debugPrint('❌ Debug - Widget not mounted, skipping _loadProductsData');
      return;
    }

    setState(() {
      isLoadingProducts = true;
    });

    try {
      // Check Supabase connection
      debugPrint('🔍 Debug - Checking Supabase connection');
      final client = SupabaseService.client;
      debugPrint('🔍 Debug - Supabase client: $client');

      // Check current user
      final currentUser = client.auth.currentUser;
      debugPrint('🔍 Debug - Current user: ${currentUser?.id}');
      debugPrint('🔍 Debug - Current user email: ${currentUser?.email}');

      // Check if user is authenticated
      final session = client.auth.currentSession;
      debugPrint(
          '🔍 Debug - Current session: ${session?.accessToken != null ? 'Valid' : 'Invalid'}');

      debugPrint('🔄 Debug - Creating management repository');
      final managementRepository =
          ManagementRepositoryImpl(SupabaseService.client);

      // Debug store ID and local storage
      debugPrint('🔍 Debug - Checking local storage data');
      final storeId = await LocalStorageService.getStoreId();
      debugPrint('🔍 Debug - Store ID from local storage: $storeId');

      final roleData = await LocalStorageService.getRoleAssignmentData();
      debugPrint('🔍 Debug - Role assignment data: $roleData');

      final storeData = await LocalStorageService.getStoreData();
      debugPrint('🔍 Debug - Store data: $storeData');

      if (storeId == null) {
        throw Exception('Store ID not found in local storage');
      }

      debugPrint('🔄 Debug - Creating getAllProductsUseCase');
      final getAllProductsUseCase = GetAllProductsUseCase(managementRepository);

      debugPrint('🔄 Debug - Executing getAllProductsUseCase');
      final productsList = await getAllProductsUseCase.execute();

      debugPrint(
          '✅ Debug - Products loaded successfully: ${productsList.length} products');
      debugPrint(
          '🔍 Debug - Products: ${productsList.map((p) => p.name).toList()}');

      if (mounted) {
        setState(() {
          products = productsList;
          filteredProducts = productsList;
          isLoadingProducts = false;

          // Extract unique categories
          categories = productsList
              .map((p) => p.categoryName)
              .where((c) => c != null && c.isNotEmpty)
              .map((c) => c!)
              .toSet()
              .toList();
        });
      }

      debugPrint('✅ Debug - _loadProductsData completed successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Debug - _loadProductsData failed: $e');
      debugPrint('❌ Debug - Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isLoadingProducts = false;
        });
      }

      // Show error toast
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('Error'),
                content: Text('Gagal memuat produk: $e'),
                trailing: SizedBox(
                  height: 32,
                  child: AllnimallButton.ghost(
                    onPressed: () => overlay.close(),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    }
  }

  void _addToCart(Product product) {
    debugPrint('🔄 Debug - _addToCart called for product: ${product.name}');
    setState(() {
      final existingItemIndex = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (existingItemIndex != -1) {
        // Update quantity if item already exists
        final existingItem = cartItems[existingItemIndex];
        cartItems[existingItemIndex] = CartItem(
          id: existingItem.id,
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
          storeId: existingItem.storeId,
          createdAt: existingItem.createdAt,
        );
        debugPrint(
            '✅ Debug - Updated existing cart item quantity: ${cartItems[existingItemIndex].quantity}');
      } else {
        // Add new item to cart
        final newCartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          quantity: 1,
          storeId: product.storeId,
          createdAt: DateTime.now(),
        );
        cartItems.add(newCartItem);
        debugPrint(
            '✅ Debug - Added new cart item: ${newCartItem.product.name}');
      }
      debugPrint('🔍 Debug - Total cart items: ${cartItems.length}');
    });
  }

  void _removeFromCart(String cartItemId) {
    setState(() {
      cartItems.removeWhere((item) => item.id == cartItemId);
    });
  }

  void _updateQuantity(String cartItemId, int newQuantity) {
    setState(() {
      final itemIndex = cartItems.indexWhere((item) => item.id == cartItemId);
      if (itemIndex != -1) {
        final item = cartItems[itemIndex];
        if (newQuantity > 0) {
          cartItems[itemIndex] = CartItem(
            id: item.id,
            product: item.product,
            quantity: newQuantity,
            storeId: item.storeId,
            createdAt: item.createdAt,
          );
        } else {
          cartItems.removeAt(itemIndex);
        }
      }
    });
  }

  double get totalPrice =>
      cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  Widget _buildProductImage(Product product) {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.imageUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon(product);
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.slate[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      );
    }
    return _buildPlaceholderIcon(product);
  }

  Widget _buildPlaceholderIcon(Product product) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: product.stock > 0 ? Colors.blue[50] : Colors.slate[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        Icons.pets,
        size: 24,
        color: product.stock > 0 ? Colors.blue[600] : Colors.slate[400],
      ),
    );
  }

  String _getFirstName(String fullName) {
    final parts = fullName.split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts.first[0]}${parts.last[0]}';
    } else {
      return name.length > 0 ? name[0] : 'U';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthGuard(
      child: Scaffold(
        child: Row(
          children: [
            // Sidebar
            const Sidebar(),
            // Left side - Product grid
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.slate[100]),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Builder(
                            builder: (context) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(businessName ?? 'Merchant').bold(),
                                  Text(storeName ?? 'Toko').muted().small(),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // User info
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getFirstName(userName ?? 'Kasir'),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ).small(),
                                  const Gap(4),
                                  Text(
                                    '|',
                                    style: TextStyle(
                                      color: Colors.neutral[100],
                                    ),
                                  ).small(),
                                  const Gap(4),
                                  Text(
                                    'Kasir',
                                    style: TextStyle(
                                      color: Colors.neutral[100],
                                    ),
                                  ).small(),
                                ],
                              ),
                              const Gap(8),
                              // Avatar
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _getInitials(userName ?? 'K'),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Search and Filter Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Search Input
                        Expanded(
                          child: AllnimallTextInput(
                            controller: _searchController,
                            placeholder: 'Cari produk...',
                            features: const [
                              InputFeature.clear(),
                            ],
                          ),
                        ),
                        const Gap(16),
                        // Category Filter
                        SizedBox(
                          width: 200,
                          child: AllnimallSelect<String>(
                            value: selectedCategory,
                            onChanged: _onCategoryChanged,
                            placeholder: const Text('Semua Kategori'),
                            searchPlaceholder: 'Cari kategori...',
                            items: categories,
                            itemBuilder: (context, category) {
                              return Text(category);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Product grid
                  Expanded(
                    child: isLoadingProducts
                        ? const ProductLoading()
                        : filteredProducts.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.inventory_2_outlined,
                                      size: 64,
                                      color: Colors.slate[100],
                                    ),
                                    const SizedBox(height: 16),
                                    const Text('Tidak ada produk')
                                        .muted()
                                        .large(),
                                    const SizedBox(height: 8),
                                    const Text(
                                            'Belum ada produk yang ditambahkan')
                                        .muted()
                                        .small(),
                                    const SizedBox(height: 16),
                                    SizedBox(
                                      width: 120,
                                      height: 36,
                                      child: AllnimallButton.primary(
                                        onPressed: () => _loadProductsData(),
                                        child: const Text(
                                          'Muat Ulang',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(16),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.2,
                                ),
                                itemCount: filteredProducts.length + 1,
                                itemBuilder: (context, index) {
                                  // First item is always the "Add Product" placeholder
                                  if (index == 0) {
                                    return SurfaceCard(
                                      padding: const EdgeInsets.all(12),
                                      child: Clickable(
                                        onPressed: () {
                                          // TODO: Navigate to add product page
                                        },
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                size: 20,
                                                color: Colors.blue[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text('Tambah Produk')
                                                .semiBold()
                                                .small(),
                                            const SizedBox(height: 4),
                                            const Text('Klik untuk menambah')
                                                .muted()
                                                .xSmall(),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Regular product items
                                  final product = filteredProducts[index - 1];
                                  return SurfaceCard(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildProductImage(product),
                                        const SizedBox(height: 8),
                                        Text(product.name).semiBold(),
                                        const SizedBox(height: 4),
                                        Text('Rp ${product.price.toStringAsFixed(0)}')
                                            .muted()
                                            .small(),
                                        const SizedBox(height: 4),
                                        Text('Stok: ${product.stock}')
                                            .muted()
                                            .xSmall(),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          height: 32,
                                          child: AllnimallButton.primary(
                                            onPressed: product.stock > 0
                                                ? () => _addToCart(product)
                                                : null,
                                            child: const Text(
                                              'Tambah',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
            // Right side - Cart
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.slate[100]),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Keranjang Belanja').bold().large,
                    const SizedBox(height: 16),
                    // Cart items
                    Expanded(
                      child: isLoadingCart
                          ? const CartLoading()
                          : cartItems.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 64,
                                        color: Colors.slate[100],
                                      ),
                                      const SizedBox(height: 16),
                                      const Text('Keranjang kosong')
                                          .muted()
                                          .large(),
                                      const SizedBox(height: 8),
                                      const Text(
                                              'Pilih produk untuk ditambahkan ke keranjang')
                                          .muted()
                                          .small(),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: cartItems.length,
                                  itemBuilder: (context, index) {
                                    final cartItem = cartItems[index];
                                    return SurfaceCard(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    Text(cartItem.product.name)
                                                        .semiBold(),
                                              ),
                                              IconButton.ghost(
                                                onPressed: () =>
                                                    _removeFromCart(
                                                        cartItem.id),
                                                icon: const Icon(Icons.close),
                                                size: ButtonSize.small,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text('Rp ${cartItem.product.price.toStringAsFixed(0)}')
                                                  .muted()
                                                  .small(),
                                              const Spacer(),
                                              Row(
                                                children: [
                                                  AllnimallIconButton.ghost(
                                                    onPressed: () =>
                                                        _updateQuantity(
                                                            cartItem.id,
                                                            cartItem.quantity -
                                                                1),
                                                    icon: const Icon(
                                                        Icons.remove),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text('${cartItem.quantity}')
                                                      .semiBold(),
                                                  const SizedBox(width: 8),
                                                  AllnimallIconButton.ghost(
                                                    onPressed: () =>
                                                        _updateQuantity(
                                                            cartItem.id,
                                                            cartItem.quantity +
                                                                1),
                                                    icon: const Icon(Icons.add),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text('Total: Rp ${cartItem.totalPrice.toStringAsFixed(0)}')
                                              .semiBold()
                                              .small(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                    // Cart summary
                    SurfaceCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              const Text('Total:').semiBold(),
                              const Spacer(),
                              Text('Rp ${totalPrice.toStringAsFixed(0)}')
                                  .h3()
                                  .bold(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 40,
                            child: AllnimallButton.primary(
                              onPressed: cartItems.isNotEmpty
                                  ? () {
                                      // Checkout logic
                                    }
                                  : null,
                              child: const Text(
                                'Bayar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
