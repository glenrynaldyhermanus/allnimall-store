import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallCheckbox extends StatelessWidget {
  final CheckboxState state;
  final ValueChanged<CheckboxState>? onChanged;
  final Widget? trailing;
  final bool tristate;

  const AllnimallCheckbox({
    super.key,
    required this.state,
    this.onChanged,
    this.trailing,
    this.tristate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      state: state,
      onChanged: onChanged,
      trailing: trailing,
      tristate: tristate,
    );
  }
}

// Helper class untuk membuat checkbox dengan mudah
class AllnimallCheckboxBuilder {
  static AllnimallCheckbox basic({
    required CheckboxState state,
    required ValueChanged<CheckboxState> onChanged,
    Widget? trailing,
  }) {
    return AllnimallCheckbox(
      state: state,
      onChanged: onChanged,
      trailing: trailing,
    );
  }

  static AllnimallCheckbox tristate({
    required CheckboxState state,
    required ValueChanged<CheckboxState> onChanged,
    Widget? trailing,
  }) {
    return AllnimallCheckbox(
      state: state,
      onChanged: onChanged,
      trailing: trailing,
      tristate: true,
    );
  }

  static AllnimallCheckbox withLabel({
    required CheckboxState state,
    required ValueChanged<CheckboxState> onChanged,
    required String label,
    bool tristate = false,
  }) {
    return AllnimallCheckbox(
      state: state,
      onChanged: onChanged,
      trailing: Text(label),
      tristate: tristate,
    );
  }
} 