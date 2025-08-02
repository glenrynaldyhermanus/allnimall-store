import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_icon_button.dart';

class CartLoading extends StatelessWidget {
  const CartLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header skeleton
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Keranjang Belanja').bold().large.asSkeleton(),
                const SizedBox(height: 16),
                // Cart items skeleton
                Expanded(
                  child: ListView.builder(
                    itemCount: 8, // Show 8 skeleton cart items
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // Product icon skeleton
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.slate[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Product details skeleton
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Product Name')
                                          .semiBold()
                                          .asSkeleton(),
                                      const SizedBox(height: 4),
                                      const Text('Rp 0').muted().small().asSkeleton(),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Quantity controls skeleton
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const AllnimallIconButton.ghost(
                                      onPressed: null,
                                      icon: Icon(Icons.remove),
                                    ).asSkeleton(),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 40,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.slate[300]),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Center(
                                        child: Text('0'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const AllnimallIconButton.ghost(
                                      onPressed: null,
                                      icon: Icon(Icons.add),
                                    ).asSkeleton(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Total section skeleton
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total').semiBold().asSkeleton(),
                            const Text('Rp 0').semiBold().asSkeleton(),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const AllnimallButton.primary(
                          onPressed: null,
                          child: Text('Bayar'),
                        ).asSkeleton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 