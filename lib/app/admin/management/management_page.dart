import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/widgets/navigation/appbar.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/index.dart';
import 'items/items_content.dart';
import 'services/services_content.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ManagementPage extends ConsumerStatefulWidget {
  final String? selectedMenu;

  const ManagementPage({super.key, this.selectedMenu});

  @override
  ConsumerState<ManagementPage> createState() => _ManagementPageState();
}

class _ManagementPageState extends ConsumerState<ManagementPage> {
  String _selectedMenu = 'items';

  final List<ManagementMenuItem> _menuItems = const [
    ManagementMenuItem(
      id: 'items',
      title: 'Barang',
      icon: LucideIcons.shoppingBasket,
      description: 'Kelola barang pet shop, makanan, dan lainnya',
    ),
    ManagementMenuItem(
      id: 'services',
      title: 'Jasa',
      icon: LucideIcons.showerHead,
      description: 'Kelola jasa pet shop, grooming, dan lainnya',
    ),
    ManagementMenuItem(
      id: 'inventory',
      title: 'Inventory',
      icon: LucideIcons.warehouse,
      description: 'Kelola stok barang',
    ),
    ManagementMenuItem(
      id: 'categories',
      title: 'Kategori',
      icon: LucideIcons.archive,
      description: 'Kelola kategori barang dan jasa',
    ),
    ManagementMenuItem(
      id: 'customers',
      title: 'Pelanggan',
      icon: LucideIcons.userRound,
      description: 'Kelola data pemilik hewan',
    ),
    ManagementMenuItem(
      id: 'pets',
      title: 'Hewan Peliharaan',
      icon: LucideIcons.pawPrint,
      description: 'Kelola data hewan peliharaan',
    ),
    ManagementMenuItem(
      id: 'suppliers',
      title: 'Supplier',
      icon: LucideIcons.truck,
      description: 'Kelola data supplier',
    ),
    ManagementMenuItem(
      id: 'discounts',
      title: 'Diskon',
      icon: LucideIcons.tag,
      description: 'Kelola diskon dan promo',
    ),
    ManagementMenuItem(
      id: 'taxes',
      title: 'Pajak',
      icon: LucideIcons.scrollText,
      description: 'Pengaturan pajak barang dan jasa',
    ),
    ManagementMenuItem(
      id: 'expenses',
      title: 'Biaya',
      icon: LucideIcons.banknote,
      description: 'Kelola biaya operasional toko',
    ),
    ManagementMenuItem(
      id: 'loyalty',
      title: 'Loyalty',
      icon: LucideIcons.gift,
      description: 'Program loyalitas pelanggan',
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
      case 'items':
        return const ItemsContent();
      case 'services':
        return const ServicesContent();
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
