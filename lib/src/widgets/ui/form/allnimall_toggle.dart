import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget child;

  const AllnimallToggle({
    super.key,
    required this.value,
    this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Toggle(
      value: value,
      onChanged: onChanged,
      child: child,
    );
  }
}

// Helper class untuk membuat toggle dengan mudah
class AllnimallToggleBuilder {
  static AllnimallToggle basic({
    required bool value,
    required ValueChanged<bool> onChanged,
    required Widget child,
  }) {
    return AllnimallToggle(
      value: value,
      onChanged: onChanged,
      child: child,
    );
  }

  static AllnimallToggle withText({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String text,
  }) {
    return AllnimallToggle(
      value: value,
      onChanged: onChanged,
      child: Text(text),
    );
  }

  static AllnimallToggle icon({
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return AllnimallToggle(
      value: value,
      onChanged: onChanged,
      child: Icon(icon),
    );
  }
}
