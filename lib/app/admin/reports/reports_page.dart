import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:allnimall_store/src/widgets/navigation/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  String _selectedMenu = 'sales';

  final List<ReportMenuItem> _menuItems = [
    ReportMenuItem(
      id: 'sales',
      title: 'Laporan Penjualan',
      icon: Icons.trending_up_outlined,
      description: 'Laporan penjualan harian, mingguan, bulanan',
    ),
    ReportMenuItem(
      id: 'inventory',
      title: 'Laporan Inventory',
      icon: Icons.inventory_outlined,
      description: 'Laporan stok masuk, keluar, dan sisa',
    ),
    ReportMenuItem(
      id: 'financial',
      title: 'Laporan Keuangan',
      icon: Icons.account_balance_outlined,
      description: 'Laporan laba rugi, cash flow',
    ),
    ReportMenuItem(
      id: 'products',
      title: 'Laporan Produk',
      icon: Icons.bar_chart_outlined,
      description: 'Produk terlaris, slow moving',
    ),
    ReportMenuItem(
      id: 'customers',
      title: 'Laporan Pelanggan',
      icon: Icons.people_alt_outlined,
      description: 'Analisis pelanggan dan loyalitas',
    ),
    ReportMenuItem(
      id: 'staff',
      title: 'Laporan Karyawan',
      icon: Icons.work_outline,
      description: 'Performa dan aktivitas karyawan',
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
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBackground,
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.border,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.analytics,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Laporan',
                          style: _getSystemFont(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => context.go('/pos'),
                          tooltip: 'Kembali ke POS',
                        ),
                      ],
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Row(
                      children: [
                        // Left Panel - Menu List
                        Container(
                          width: 300,
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
                                  'Jenis Laporan',
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
                          child: Padding(
                            padding: const EdgeInsets.all(24),
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

    return _buildComingSoonContent(selectedItem);
  }

  Widget _buildComingSoonContent(ReportMenuItem item) {
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

class ReportMenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String description;

  ReportMenuItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });
}
