import 'package:allnimall_store/src/providers/cashier_provider.dart';
import 'package:allnimall_store/src/core/theme/app_theme.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class PosCart extends StatelessWidget {
  final CashierLoaded state;
  final VoidCallback onClearCart;
  final void Function(int index, int newQuantity) onUpdateQuantity;
  final VoidCallback onProcessPayment;

  const PosCart({
    super.key,
    required this.state,
    required this.onClearCart,
    required this.onUpdateQuantity,
    required this.onProcessPayment,
  });

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
    return Column(
      children: [
        // Cart Items
        Expanded(
          child: Card(
            child: Column(
              children: [
                // Cart Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      const Gap(12),
                      const Text('Cart').semiBold(),
                      const Spacer(),
                      if (state.cartItems.isNotEmpty)
                        IconButton(
                          variance: ButtonVariance.ghost,
                          icon: const Icon(
                            Icons.clear_rounded,
                            color: AppColors.secondaryText,
                          ),
                          onPressed: onClearCart,
                        ),
                    ],
                  ),
                ),
                // Cart Content
                Expanded(
                  child: state.cartItems.isEmpty
                      ? _buildEmptyCart()
                      : _buildCartItems(),
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
        // Totals
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: _getSystemFont(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Text(
                      _formatCurrency(state.total),
                      style: _getSystemFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax (10%):',
                      style: _getSystemFont(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                    Text(
                      _formatCurrency(state.tax),
                      style: _getSystemFont(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: _getSystemFont(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _formatCurrency(state.finalTotal),
                      style: _getSystemFont(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
        // Payment Button
        SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            onPressed: state.cartItems.isEmpty ? null : onProcessPayment,
            child: const Text('Process Payment'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.secondaryText,
            ),
            const Gap(16),
            Text(
              'Cart is empty',
              style: _getSystemFont(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.secondaryText,
              ),
            ),
            const Gap(8),
            Text(
              'Add items to get started',
              style: _getSystemFont(
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.cartItems.length,
      itemBuilder: (context, index) {
        final item = state.cartItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.product.name,
                      style: _getSystemFont(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    _formatCurrency(item.product.price),
                    style: _getSystemFont(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Quantity',
                    style: _getSystemFont(
                      fontSize: 12,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          variance: ButtonVariance.ghost,
                          icon: const Icon(
                            Icons.remove,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          onPressed: () =>
                              onUpdateQuantity(index, item.quantity - 1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: _getSystemFont(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          variance: ButtonVariance.ghost,
                          icon: const Icon(
                            Icons.add,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          onPressed: () =>
                              onUpdateQuantity(index, item.quantity + 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(0)}.000.000';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).toStringAsFixed(0)}.000';
    } else {
      return 'Rp ${amount.toStringAsFixed(0)}';
    }
  }
}
