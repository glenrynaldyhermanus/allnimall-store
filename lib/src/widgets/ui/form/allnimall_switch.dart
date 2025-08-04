import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? trailing;

  const AllnimallSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      trailing: trailing,
    );
  }
}

// Helper class untuk membuat switch dengan mudah
class AllnimallSwitchBuilder {
  static AllnimallSwitch basic({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AllnimallSwitch(
      value: value,
      onChanged: onChanged,
    );
  }

  static AllnimallSwitch withLabel({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
  }) {
    return AllnimallSwitch(
      value: value,
      onChanged: onChanged,
      trailing: Text(label),
    );
  }

  static AllnimallSwitch withCustomTrailing({
    required bool value,
    required ValueChanged<bool> onChanged,
    required Widget trailing,
  }) {
    return AllnimallSwitch(
      value: value,
      onChanged: onChanged,
      trailing: trailing,
    );
  }
} 