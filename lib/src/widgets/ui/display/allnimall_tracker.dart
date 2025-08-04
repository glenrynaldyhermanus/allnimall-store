import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallTracker extends StatelessWidget {
  final List<TrackerData> data;

  const AllnimallTracker({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Tracker(data: data);
  }
}

// Helper class untuk membuat tracker dengan mudah
class AllnimallTrackerBuilder {
  static AllnimallTracker fromData({
    required List<TrackerData> data,
  }) {
    return AllnimallTracker(data: data);
  }
}
