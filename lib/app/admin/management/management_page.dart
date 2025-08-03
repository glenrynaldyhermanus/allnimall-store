import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/providers/management_provider.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'widgets/index.dart';

class ManagementPage extends ConsumerStatefulWidget {
  final String? selectedMenu;

  const ManagementPage({super.key, this.selectedMenu});

  @override
  ConsumerState<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends ConsumerState<ManagementPage> {
  String _selectedMenu = 'products';

  final List<ManagementMenuItem> _menuItems = const [
    ManagementMenuItem(
      id: 'products',
      title: 'Produk',
      icon: Icons.inventory_2_outlined,
      description: 'Kelola daftar produk pet shop',
    ),
    ManagementMenuItem(
      id: 'inventory',
      title: 'Inventory',
      icon: Icons.warehouse_outlined,
      description: 'Kelola stok barang',
    ),
    ManagementMenuItem(
      id: 'categories',
      title: 'Kategori',
      icon: Icons.category_outlined,
      description: 'Kelola kategori produk',
    ),
    ManagementMenuItem(
      id: 'customers',
      title: 'Pelanggan',
      icon: Icons.people_outline,
      description: 'Kelola data pemilik hewan',
    ),
    ManagementMenuItem(
      id: 'pets',
      title: 'Hewan Peliharaan',
      icon: Icons.pets,
      description: 'Kelola data hewan peliharaan',
    ),
    ManagementMenuItem(
      id: 'suppliers',
      title: 'Supplier',
      icon: Icons.local_shipping_outlined,
      description: 'Kelola data supplier',
    ),
    ManagementMenuItem(
      id: 'discounts',
      title: 'Diskon',
      icon: Icons.local_offer_outlined,
      description: 'Kelola diskon dan promo',
    ),
    ManagementMenuItem(
      id: 'taxes',
      title: 'Pajak',
      icon: Icons.receipt_long_outlined,
      description: 'Pengaturan pajak',
    ),
    ManagementMenuItem(
      id: 'expenses',
      title: 'Biaya',
      icon: Icons.money_off_outlined,
      description: 'Kelola biaya operasional',
    ),
    ManagementMenuItem(
      id: 'loyalty',
      title: 'Loyalty',
      icon: Icons.card_giftcard_outlined,
      description: 'Program loyalitas',
    ),
  ];

  // Helper function untuk menggunakan system font
  TextStyle _getSystemFont({
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedMenu != null) {
      _selectedMenu = widget.selectedMenu!;
    }
    // Load initial data based on selected menu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataForSelectedMenu();
    });
  }

  void _loadDataForSelectedMenu() {
    switch (_selectedMenu) {
      case 'inventory':
        ref.read(managementProvider.notifier).loadInventory();
        break;
      case 'categories':
        ref.read(managementProvider.notifier).loadCategories();
        break;
      case 'customers':
        ref.read(managementProvider.notifier).loadCustomers();
        break;
      case 'suppliers':
        ref.read(managementProvider.notifier).loadSuppliers();
        break;
      case 'discounts':
        ref.read(managementProvider.notifier).loadDiscounts();
        break;
      case 'expenses':
        ref.read(managementProvider.notifier).loadExpenses();
        break;
      case 'loyalty':
        ref.read(managementProvider.notifier).loadLoyaltyPrograms();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.surfaceBackground,
        child: Row(
          children: [
            // Sidebar
            const Sidebar(),
            // Main Content
            Expanded(
              child: Column(
                children: [
                  // Page Header
                  AllnimallAppBar(),
                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        // Left Panel - Menu List
                        Container(
                          width: MediaQuery.of(context).size.width < 1200
                              ? 250
                              : 300,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBackground,
                            border: Border(
                              right: BorderSide(
                                color: AppColors.border,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  'Data Management',
                                  style: _getSystemFont(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  itemCount: _menuItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _menuItems[index];
                                    final isSelected = _selectedMenu == item.id;

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          onTap: () {
                                            setState(() {
                                              _selectedMenu = item.id;
                                            });
                                            _loadDataForSelectedMenu();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.primary
                                                      .withValues(alpha: 0.1)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: isSelected
                                                  ? Border.all(
                                                      color: AppColors.primary
                                                          .withValues(
                                                              alpha: 0.3),
                                                      width: 1,
                                                    )
                                                  : null,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  item.icon,
                                                  size: 20,
                                                  color: isSelected
                                                      ? AppColors.primary
                                                      : AppColors.secondaryText,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: _getSystemFont(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: isSelected
                                                              ? AppColors
                                                                  .primary
                                                              : AppColors
                                                                  .primaryText,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        item.description,
                                                        style: _getSystemFont(
                                                          fontSize: 12,
                                                          color: AppColors
                                                              .secondaryText,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Right Panel - Content
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: _buildContent(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final selectedItem =
        _menuItems.firstWhere((item) => item.id == _selectedMenu);

    return Column(
      children: [
        _buildContentByMenu(selectedItem),
        const SizedBox(height: 24), // Bottom padding
      ],
    );
  }

  Widget _buildContentByMenu(ManagementMenuItem selectedItem) {
    switch (_selectedMenu) {
      case 'products':
        return const ProductsContent();
      case 'inventory':
        return const InventoryContent();
      case 'categories':
        return const CategoriesContent();
      case 'customers':
        return const CustomersContent();
      case 'pets':
        return const PetsContent();
      case 'suppliers':
        return const SuppliersContent();
      case 'discounts':
        return const DiscountsContent();
      case 'taxes':
        return const TaxesContent();
      case 'expenses':
        return const ExpensesContent();
      case 'loyalty':
        return const LoyaltyContent();
      default:
        return _buildComingSoonContent(selectedItem);
    }
  }

  Widget _buildComingSoonContent(ManagementMenuItem item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 64,
              color: AppColors.secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              item.title,
              style: _getSystemFont(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.description,
              style: _getSystemFont(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Coming Soon',
                style: _getSystemFont(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManagementMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String description;

  const ManagementMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });
}
