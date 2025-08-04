import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallRadioGroup<T> extends StatelessWidget {
  final T? value;
  final ValueChanged<T>? onChanged;
  final Widget child;

  const AllnimallRadioGroup({
    super.key,
    this.value,
    this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      value: value,
      onChanged: onChanged,
      child: child,
    );
  }
}

class AllnimallRadioItem<T> extends StatelessWidget {
  final T value;
  final Widget trailing;

  const AllnimallRadioItem({
    super.key,
    required this.value,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return RadioItem<T>(
      value: value,
      trailing: trailing,
    );
  }
}

// Helper class untuk membuat radio group dengan mudah
class AllnimallRadioGroupBuilder {
  static AllnimallRadioGroup<int> basic({
    int? value,
    ValueChanged<int>? onChanged,
    required List<AllnimallRadioItem<int>> items,
  }) {
    return AllnimallRadioGroup<int>(
      value: value,
      onChanged: onChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  static AllnimallRadioGroup<String> string({
    String? value,
    ValueChanged<String>? onChanged,
    required List<AllnimallRadioItem<String>> items,
  }) {
    return AllnimallRadioGroup<String>(
      value: value,
      onChanged: onChanged,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  static AllnimallRadioItem<int> item({
    required int value,
    required String label,
  }) {
    return AllnimallRadioItem<int>(
      value: value,
      trailing: Text(label),
    );
  }

  static AllnimallRadioItem<String> stringItem({
    required String value,
    required String label,
  }) {
    return AllnimallRadioItem<String>(
      value: value,
      trailing: Text(label),
    );
  }
} 