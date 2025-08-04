import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallDivider extends StatelessWidget {
  final Widget? child;
  final bool isVertical;

  const AllnimallDivider({
    super.key,
    this.child,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isVertical) {
      return VerticalDivider(child: child);
    }
    return Divider(child: child);
  }
}

// Helper class untuk membuat divider dengan mudah
class AllnimallDividerBuilder {
  static AllnimallDivider horizontal({
    Widget? child,
  }) {
    return AllnimallDivider(
      child: child,
      isVertical: false,
    );
  }

  static AllnimallDivider vertical({
    Widget? child,
  }) {
    return AllnimallDivider(
      child: child,
      isVertical: true,
    );
  }

  static AllnimallDivider withText({
    required String text,
    bool isVertical = false,
  }) {
    return AllnimallDivider(
      child: Text(text),
      isVertical: isVertical,
    );
  }

  static AllnimallDivider simple({
    bool isVertical = false,
  }) {
    return AllnimallDivider(isVertical: isVertical);
  }
}
