import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallDotIndicator extends StatelessWidget {
  final int index;
  final int length;
  final ValueChanged<int> onChanged;

  const AllnimallDotIndicator({
    super.key,
    required this.index,
    required this.length,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DotIndicator(
      index: index,
      length: length,
      onChanged: onChanged,
    );
  }
}

// Helper class untuk membuat dot indicator dengan mudah
class AllnimallDotIndicatorBuilder {
  static AllnimallDotIndicator basic({
    required int index,
    required int length,
    required ValueChanged<int> onChanged,
  }) {
    return AllnimallDotIndicator(
      index: index,
      length: length,
      onChanged: onChanged,
    );
  }
}
