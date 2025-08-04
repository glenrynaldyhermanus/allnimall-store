import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallTabList extends StatelessWidget {
  final int index;
  final List<TabChild> children;
  final ValueChanged<int> onChanged;

  const AllnimallTabList({
    super.key,
    required this.index,
    required this.children,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TabList(
      index: index,
      children: children,
      onChanged: onChanged,
    );
  }
}

// Helper class untuk membuat tab list dengan mudah
class AllnimallTabListBuilder {
  static AllnimallTabList basic({
    required int index,
    required List<String> labels,
    required ValueChanged<int> onChanged,
  }) {
    return AllnimallTabList(
      index: index,
      onChanged: onChanged,
      children: labels.map((label) => TabItem(child: Text(label))).toList(),
    );
  }

  static AllnimallTabList withCustomItems({
    required int index,
    required List<TabItem> items,
    required ValueChanged<int> onChanged,
  }) {
    return AllnimallTabList(
      index: index,
      onChanged: onChanged,
      children: items,
    );
  }
}
