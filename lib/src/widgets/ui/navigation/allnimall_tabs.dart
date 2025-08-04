import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallTabs extends StatelessWidget {
  final int index;
  final List<TabChild> children;
  final ValueChanged<int> onChanged;

  const AllnimallTabs({
    super.key,
    required this.index,
    required this.children,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Tabs(
      index: index,
      children: children,
      onChanged: onChanged,
    );
  }
}

class AllnimallTabItem extends StatelessWidget {
  final Widget child;

  const AllnimallTabItem({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TabItem(child: child);
  }
}

// Helper class untuk membuat tabs dengan mudah
class AllnimallTabsBuilder {
  static AllnimallTabs basic({
    required int index,
    required List<String> labels,
    required ValueChanged<int> onChanged,
  }) {
    return AllnimallTabs(
      index: index,
      onChanged: onChanged,
      children: labels.map((label) => TabItem(child: Text(label))).toList(),
    );
  }

  static AllnimallTabs withCustomItems({
    required int index,
    required List<TabItem> items,
    required ValueChanged<int> onChanged,
  }) {
    return AllnimallTabs(
      index: index,
      onChanged: onChanged,
      children: items,
    );
  }

  static TabItem item({
    required String label,
  }) {
    return TabItem(child: Text(label));
  }

  static TabItem custom({
    required Widget child,
  }) {
    return TabItem(child: child);
  }
}
