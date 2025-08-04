import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/index.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.selectedMenu != null) {
      _selectedMenu = widget.selectedMenu!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: Container(
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
                  const AllnimallAppBar(),
                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        // Left Panel - Menu List
                        ManagementMenuWidget(
                          menuItems: _menuItems,
                          initialSelectedMenu: _selectedMenu,
                          onMenuSelected: (menuId) {
                            setState(() {
                              _selectedMenu = menuId;
                            });
                          },
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
        return Container();
    }
  }
}
