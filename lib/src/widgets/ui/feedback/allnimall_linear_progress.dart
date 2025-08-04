import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallLinearProgress extends StatelessWidget {
  final double? value;
  final double? width;
  final double height;

  const AllnimallLinearProgress({
    super.key,
    this.value,
    this.width,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: LinearProgressIndicator(
        value: value,
      ),
    );
  }
}

// Helper class untuk membuat linear progress dengan mudah
class AllnimallLinearProgressBuilder {
  static AllnimallLinearProgress indeterminate({
    double? width,
    double height = 4,
  }) {
    return AllnimallLinearProgress(
      width: width,
      height: height,
    );
  }

  static AllnimallLinearProgress determinate({
    required double value,
    double? width,
    double height = 4,
  }) {
    return AllnimallLinearProgress(
      value: value.clamp(0.0, 1.0),
      width: width,
      height: height,
    );
  }

  static AllnimallLinearProgress percentage({
    required double percentage,
    double? width,
    double height = 4,
  }) {
    return AllnimallLinearProgress(
      value: (percentage / 100).clamp(0.0, 1.0),
      width: width,
      height: height,
    );
  }

  static AllnimallLinearProgress thin({
    double? value,
    double? width,
  }) {
    return AllnimallLinearProgress(
      value: value,
      width: width,
      height: 2,
    );
  }

  static AllnimallLinearProgress thick({
    double? value,
    double? width,
  }) {
    return AllnimallLinearProgress(
      value: value,
      width: width,
      height: 8,
    );
  }
}
