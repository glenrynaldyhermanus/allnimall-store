import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallCircularProgress extends StatelessWidget {
  final double? value;
  final double size;

  const AllnimallCircularProgress({
    super.key,
    this.value,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: value,
      size: size,
    );
  }
}

// Helper class untuk membuat circular progress dengan mudah
class AllnimallCircularProgressBuilder {
  static AllnimallCircularProgress indeterminate({
    double size = 40,
  }) {
    return AllnimallCircularProgress(
      size: size,
    );
  }

  static AllnimallCircularProgress determinate({
    required double value,
    double size = 40,
  }) {
    return AllnimallCircularProgress(
      value: value.clamp(0.0, 1.0),
      size: size,
    );
  }

  static AllnimallCircularProgress percentage({
    required double percentage,
    double size = 40,
  }) {
    return AllnimallCircularProgress(
      value: (percentage / 100).clamp(0.0, 1.0),
      size: size,
    );
  }

  static AllnimallCircularProgress small({
    double? value,
  }) {
    return AllnimallCircularProgress(
      value: value,
      size: 24,
    );
  }

  static AllnimallCircularProgress large({
    double? value,
  }) {
    return AllnimallCircularProgress(
      value: value,
      size: 64,
    );
  }
}
