import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallAlert extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Widget? leading;
  final Widget? trailing;

  const AllnimallAlert({
    super.key,
    required this.title,
    required this.content,
    this.leading,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Alert(
      title: title,
      content: content,
      leading: leading,
      trailing: trailing,
    );
  }
}

// Helper class untuk membuat alert dengan mudah
class AllnimallAlertBuilder {
  static AllnimallAlert info({
    required String title,
    required String content,
    IconData? icon,
    Widget? trailing,
  }) {
    return AllnimallAlert(
      title: Text(title),
      content: Text(content),
      leading: icon != null ? Icon(icon) : const Icon(Icons.info_outline),
      trailing: trailing,
    );
  }

  static AllnimallAlert success({
    required String title,
    required String content,
    Widget? trailing,
  }) {
    return AllnimallAlert(
      title: Text(title),
      content: Text(content),
      leading: const Icon(Icons.check_circle_outline),
      trailing: trailing,
    );
  }

  static AllnimallAlert warning({
    required String title,
    required String content,
    Widget? trailing,
  }) {
    return AllnimallAlert(
      title: Text(title),
      content: Text(content),
      leading: const Icon(Icons.warning_amber_outlined),
      trailing: trailing,
    );
  }

  static AllnimallAlert error({
    required String title,
    required String content,
    Widget? trailing,
  }) {
    return AllnimallAlert(
      title: Text(title),
      content: Text(content),
      leading: const Icon(Icons.error_outline),
      trailing: trailing,
    );
  }

  static AllnimallAlert custom({
    required Widget title,
    required Widget content,
    Widget? leading,
    Widget? trailing,
  }) {
    return AllnimallAlert(
      title: title,
      content: content,
      leading: leading,
      trailing: trailing,
    );
  }
} 