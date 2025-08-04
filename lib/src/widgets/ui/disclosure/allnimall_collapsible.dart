import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallCollapsible extends StatelessWidget {
  final List<Widget> children;

  const AllnimallCollapsible({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Collapsible(
      children: children,
    );
  }
}

class AllnimallCollapsibleTrigger extends StatelessWidget {
  final Widget child;

  const AllnimallCollapsibleTrigger({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CollapsibleTrigger(
      child: child,
    );
  }
}

class AllnimallCollapsibleContent extends StatelessWidget {
  final Widget child;

  const AllnimallCollapsibleContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CollapsibleContent(
      child: child,
    );
  }
}

// Helper class untuk membuat collapsible dengan mudah
class AllnimallCollapsibleBuilder {
  static AllnimallCollapsible simple({
    required Widget trigger,
    required Widget content,
  }) {
    return AllnimallCollapsible(
      children: [
        AllnimallCollapsibleTrigger(child: trigger),
        AllnimallCollapsibleContent(child: content),
      ],
    );
  }

  static AllnimallCollapsible list({
    required Widget trigger,
    required List<Widget> contentItems,
  }) {
    return AllnimallCollapsible(
      children: [
        AllnimallCollapsibleTrigger(child: trigger),
        ...contentItems.map((item) => AllnimallCollapsibleContent(child: item)),
      ],
    );
  }
} 