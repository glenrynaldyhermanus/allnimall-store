import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallBreadcrumb extends StatelessWidget {
  final List<Widget> children;
  final Widget? separator;

  const AllnimallBreadcrumb({
    super.key,
    required this.children,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return Breadcrumb(
      separator: separator ?? Breadcrumb.arrowSeparator,
      children: children,
    );
  }
}

// Helper class untuk membuat breadcrumb dengan mudah
class AllnimallBreadcrumbBuilder {
  static AllnimallBreadcrumb basic({
    required List<Widget> children,
    Widget? separator,
  }) {
    return AllnimallBreadcrumb(
      children: children,
      separator: separator,
    );
  }

  static AllnimallBreadcrumb withTextButtons({
    required List<String> items,
    required List<VoidCallback> onPressed,
    Widget? separator,
  }) {
    final children = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i < items.length - 1) {
        children.add(
          TextButton(
            onPressed: onPressed[i],
            density: ButtonDensity.compact,
            child: Text(items[i]),
          ),
        );
      } else {
        children.add(Text(items[i]));
      }
    }

    return AllnimallBreadcrumb(
      children: children,
      separator: separator,
    );
  }

  static AllnimallBreadcrumb withMoreDots({
    required List<Widget> children,
    Widget? separator,
  }) {
    final items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      if (i > 0) {
        items.add(const MoreDots());
      }
      items.add(children[i]);
    }

    return AllnimallBreadcrumb(
      children: items,
      separator: separator,
    );
  }
}
