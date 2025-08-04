import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallRadioCard<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const AllnimallRadioCard({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RadioCard<T>(
      value: value,
      child: child,
    );
  }
}

// Helper class untuk membuat radio card dengan mudah
class AllnimallRadioCardBuilder {
  static AllnimallRadioCard<int> basic({
    required int value,
    required Widget child,
  }) {
    return AllnimallRadioCard<int>(
      value: value,
      child: child,
    );
  }

  static AllnimallRadioCard<String> string({
    required String value,
    required Widget child,
  }) {
    return AllnimallRadioCard<String>(
      value: value,
      child: child,
    );
  }

  static AllnimallRadioCard<int> withContent({
    required int value,
    required String title,
    required String content,
  }) {
    return AllnimallRadioCard<int>(
      value: value,
      child: Basic(
        title: Text(title),
        content: Text(content),
      ),
    );
  }

  static AllnimallRadioCard<String> withStringContent({
    required String value,
    required String title,
    required String content,
  }) {
    return AllnimallRadioCard<String>(
      value: value,
      child: Basic(
        title: Text(title),
        content: Text(content),
      ),
    );
  }
}
