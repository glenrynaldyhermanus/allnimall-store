import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallSlider extends StatelessWidget {
  final SliderValue value;
  final ValueChanged<SliderValue>? onChanged;
  final int? divisions;

  const AllnimallSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.divisions,
  });

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: value,
      onChanged: onChanged,
      divisions: divisions,
    );
  }
}

// Helper class untuk membuat slider dengan mudah
class AllnimallSliderBuilder {
  static AllnimallSlider single({
    required double value,
    ValueChanged<SliderValue>? onChanged,
    int? divisions,
  }) {
    return AllnimallSlider(
      value: SliderValue.single(value),
      onChanged: onChanged,
      divisions: divisions,
    );
  }

  static AllnimallSlider ranged({
    required double start,
    required double end,
    ValueChanged<SliderValue>? onChanged,
    int? divisions,
  }) {
    return AllnimallSlider(
      value: SliderValue.ranged(start, end),
      onChanged: onChanged,
      divisions: divisions,
    );
  }

  static AllnimallSlider withDivisions({
    required double value,
    required int divisions,
    ValueChanged<SliderValue>? onChanged,
  }) {
    return AllnimallSlider(
      value: SliderValue.single(value),
      onChanged: onChanged,
      divisions: divisions,
    );
  }

  static AllnimallSlider percentage({
    required double percentage,
    ValueChanged<SliderValue>? onChanged,
  }) {
    return AllnimallSlider(
      value: SliderValue.single(percentage / 100),
      onChanged: onChanged,
    );
  }
}
