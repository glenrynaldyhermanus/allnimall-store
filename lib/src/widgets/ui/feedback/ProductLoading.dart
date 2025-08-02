import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:allnimall_store/src/widgets/ui/form/allnimall_button.dart';

class ProductLoading extends StatelessWidget {
  const ProductLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: 16, // Show 16 skeleton items
      itemBuilder: (context, index) {
        return Card(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.pets, size: 32).asSkeleton(),
              const SizedBox(height: 8),
              const Text('Product Name')
                  .semiBold()
                  .asSkeleton(),
              const SizedBox(height: 4),
              const Text('Rp 0')
                  .muted()
                  .small()
                  .asSkeleton(),
              const SizedBox(height: 4),
              const Text('Stok: 0')
                  .muted()
                  .xSmall()
                  .asSkeleton(),
              const SizedBox(height: 8),
              const AllnimallButton.primary(
                onPressed: null,
                child: Text('Tambah'),
              ).constrained(height: 32).asSkeleton(),
            ],
          ),
        );
      },
    );
  }
} 