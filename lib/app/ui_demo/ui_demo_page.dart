import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:allnimall_store/src/widgets/allnimall_button.dart';
import 'package:allnimall_store/src/widgets/allnimall_icon_button.dart';

class UiDemoPage extends StatelessWidget {
  const UiDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      headers: const [
        AppBar(
          title: Text('UI Demo'),
          subtitle: Text('Allnimall Custom Widgets'),
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Allnimall Custom Widgets').h1(),
            const Text('Koleksi widget custom dengan animasi hover dan bounce').muted(),
            const Gap(48),
            
            // AllnimallButton Section
            const Text('AllnimallButton').h2(),
            const Text('Custom button dengan efek hover shadow dan bounce').muted(),
            const Gap(24),
            
            // PRIMARY
            const Text('PRIMARY').h3(),
            AllnimallButton.primary(
              onPressed: () {},
              child: const Text('Primary'),
            ),
            const Gap(16),
            
            // SECONDARY
            const Text('SECONDARY').h3(),
            AllnimallButton.secondary(
              onPressed: () {},
              child: const Text('Secondary'),
            ),
            const Gap(16),
            
            // OUTLINE
            const Text('OUTLINE').h3(),
            AllnimallButton.outline(
              onPressed: () {},
              child: const Text('Outlined'),
            ),
            const Gap(16),
            
            // GHOST
            const Text('GHOST').h3(),
            AllnimallButton.ghost(
              onPressed: () {},
              child: const Text('Ghost'),
            ),
            const Gap(16),
            
            // DESTRUCTIVE
            const Text('DESTRUCTIVE').h3(),
            AllnimallButton.destructive(
              onPressed: () {},
              child: const Text('Destructive'),
            ),
            const Gap(16),
            
            // LOADING STATE
            const Text('LOADING STATE').h3(),
            AllnimallButton.primary(
              onPressed: () {},
              child: const Text('Loading...'),
              isLoading: true,
            ),
            const Gap(16),
            
            // CUSTOM SIZES
            const Text('CUSTOM SIZES').h3(),
            Row(
              children: [
                AllnimallButton.primary(
                  onPressed: () {},
                  child: const Text('Small'),
                  height: 32,
                ),
                const Gap(8),
                AllnimallButton.primary(
                  onPressed: () {},
                  child: const Text('Normal'),
                  height: 48,
                ),
                const Gap(8),
                AllnimallButton.primary(
                  onPressed: () {},
                  child: const Text('Large'),
                  height: 56,
                ),
              ],
            ),
            const Gap(16),
            
            // WITH ICONS
            const Text('WITH ICONS').h3(),
            AllnimallButton.primary(
              onPressed: () {},
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 16),
                  Gap(8),
                  Text('Add Item'),
                ],
              ),
            ),
            const Gap(48),
            
            // AllnimallIconButton Section
            const Text('AllnimallIconButton').h2(),
            const Text('Custom icon button dengan efek hover shadow dan bounce').muted(),
            const Gap(24),
            
            // PRIMARY ICONS
            const Text('PRIMARY').h3(),
            Row(
              children: [
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  isLoading: true,
                ),
              ],
            ),
            const Gap(16),
            
            // SECONDARY ICONS
            const Text('SECONDARY').h3(),
            Row(
              children: [
                AllnimallIconButton.secondary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
                const Gap(8),
                AllnimallIconButton.secondary(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                const Gap(8),
                AllnimallIconButton.secondary(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
                const Gap(8),
                AllnimallIconButton.secondary(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  isLoading: true,
                ),
              ],
            ),
            const Gap(16),
            
            // OUTLINE ICONS
            const Text('OUTLINE').h3(),
            Row(
              children: [
                AllnimallIconButton.outline(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
                const Gap(8),
                AllnimallIconButton.outline(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                const Gap(8),
                AllnimallIconButton.outline(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
                const Gap(8),
                AllnimallIconButton.outline(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  isLoading: true,
                ),
              ],
            ),
            const Gap(16),
            
            // GHOST ICONS
            const Text('GHOST').h3(),
            Row(
              children: [
                AllnimallIconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                ),
                const Gap(8),
                AllnimallIconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                ),
                const Gap(8),
                AllnimallIconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
                const Gap(8),
                AllnimallIconButton.ghost(
                  onPressed: () {},
                  icon: const Icon(Icons.search),
                  isLoading: true,
                ),
              ],
            ),
            const Gap(16),
            
            // DESTRUCTIVE ICONS
            const Text('DESTRUCTIVE').h3(),
            Row(
              children: [
                AllnimallIconButton.destructive(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                ),
                const Gap(8),
                AllnimallIconButton.destructive(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                ),
                const Gap(8),
                AllnimallIconButton.destructive(
                  onPressed: () {},
                  icon: const Icon(Icons.remove),
                ),
                const Gap(8),
                AllnimallIconButton.destructive(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  isLoading: true,
                ),
              ],
            ),
            const Gap(16),
            
            // CUSTOM SIZES ICONS
            const Text('CUSTOM SIZES').h3(),
            Row(
              children: [
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  size: 32,
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  size: 40,
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  size: 48,
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  size: 56,
                ),
              ],
            ),
            const Gap(16),
            
            // CUSTOM BORDER RADIUS ICONS
            const Text('CUSTOM BORDER RADIUS').h3(),
            Row(
              children: [
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  borderRadius: BorderRadius.circular(4),
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  borderRadius: BorderRadius.circular(8),
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  borderRadius: BorderRadius.circular(12),
                ),
                const Gap(8),
                AllnimallIconButton.primary(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
            const Gap(48),
            
            // FEATURES SECTION
            const Text('Features').h2(),
            const Text('Semua widget memiliki fitur animasi yang sama').muted(),
            const Gap(24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Animasi yang Tersedia').h3(),
                    const Gap(16),
                    const Text('• Hover Shadow: Shadow muncul/hilang dengan animasi opacity'),
                    const Text('• Button Lift: Button naik 2px saat hover'),
                    const Text('• Bounce Effect: Animasi scale saat diklik'),
                    const Text('• Loading State: CircularProgressIndicator saat loading'),
                    const Text('• Customizable: Size, padding, borderRadius'),
                    const Gap(16),
                    const Text('Durasi Animasi').h4(),
                    const Text('• Hover Animation: 200ms'),
                    const Text('• Shadow Animation: 300ms'),
                    const Text('• Bounce Animation: 150ms'),
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