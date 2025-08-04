import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallStarRating extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double starSize;

  const AllnimallStarRating({
    super.key,
    required this.value,
    this.onChanged,
    this.starSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return StarRating(
      starSize: starSize,
      value: value,
      onChanged: onChanged,
    );
  }
}

// Helper class untuk membuat star rating dengan mudah
class AllnimallStarRatingBuilder {
  static AllnimallStarRating basic({
    required double value,
    ValueChanged<double>? onChanged,
  }) {
    return AllnimallStarRating(
      value: value,
      onChanged: onChanged,
    );
  }

  static AllnimallStarRating small({
    required double value,
    ValueChanged<double>? onChanged,
  }) {
    return AllnimallStarRating(
      value: value,
      onChanged: onChanged,
      starSize: 24,
    );
  }

  static AllnimallStarRating large({
    required double value,
    ValueChanged<double>? onChanged,
  }) {
    return AllnimallStarRating(
      value: value,
      onChanged: onChanged,
      starSize: 48,
    );
  }

  static AllnimallStarRating custom({
    required double value,
    required ValueChanged<double> onChanged,
    required double starSize,
  }) {
    return AllnimallStarRating(
      value: value,
      onChanged: onChanged,
      starSize: starSize,
    );
  }
}
