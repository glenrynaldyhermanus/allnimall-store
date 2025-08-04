import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool intrinsic;

  const AllnimallCard({
    super.key,
    required this.child,
    this.padding,
    this.intrinsic = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      padding: padding,
      child: child,
    );

    if (intrinsic) {
      card = card.intrinsic();
    }

    return card;
  }
}

// Helper class untuk membuat card dengan mudah
class AllnimallCardBuilder {
  static AllnimallCard basic({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return AllnimallCard(
      child: child,
      padding: padding,
    );
  }

  static AllnimallCard withPadding({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(24),
  }) {
    return AllnimallCard(
      child: child,
      padding: padding,
    );
  }

  static AllnimallCard intrinsic({
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return AllnimallCard(
      child: child,
      padding: padding,
      intrinsic: true,
    );
  }

  static AllnimallCard form({
    required String title,
    required String subtitle,
    required List<Widget> formFields,
    required List<Widget> actions,
  }) {
    return AllnimallCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title).semiBold(),
          const SizedBox(height: 4),
          Text(subtitle).muted().small(),
          const SizedBox(height: 24),
          ...formFields,
          const SizedBox(height: 24),
          Row(
            children: [
              ...actions.take(actions.length - 1),
              const Spacer(),
              actions.last,
            ],
          ),
        ],
      ),
    );
  }
} 