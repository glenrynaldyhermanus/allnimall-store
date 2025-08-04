import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallProgress extends StatelessWidget {
  final double progress;
  final double min;
  final double max;
  final double? width;

  const AllnimallProgress({
    super.key,
    required this.progress,
    this.min = 0,
    this.max = 100,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Progress(
        progress: progress.clamp(min, max),
        min: min,
        max: max,
      ),
    );
  }
}

// Helper class untuk membuat progress dengan mudah
class AllnimallProgressBuilder {
  static AllnimallProgress percentage({
    required double percentage,
    double? width,
  }) {
    return AllnimallProgress(
      progress: percentage,
      width: width,
    );
  }

  static AllnimallProgress custom({
    required double progress,
    required double min,
    required double max,
    double? width,
  }) {
    return AllnimallProgress(
      progress: progress,
      min: min,
      max: max,
      width: width,
    );
  }

  static AllnimallProgress thin({
    required double progress,
    double? width,
  }) {
    return AllnimallProgress(
      progress: progress,
      width: width,
    );
  }

  static AllnimallProgress wide({
    required double progress,
  }) {
    return AllnimallProgress(
      progress: progress,
      width: 400,
    );
  }
}
