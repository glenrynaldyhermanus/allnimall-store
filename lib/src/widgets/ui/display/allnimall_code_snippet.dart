import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallCodeSnippet extends StatelessWidget {
  final String code;
  final String mode;

  const AllnimallCodeSnippet({
    super.key,
    required this.code,
    this.mode = 'text',
  });

  @override
  Widget build(BuildContext context) {
    return CodeSnippet(
      code: code,
      mode: mode,
    );
  }
}

// Helper class untuk membuat code snippet dengan mudah
class AllnimallCodeSnippetBuilder {
  static AllnimallCodeSnippet shell({
    required String code,
  }) {
    return AllnimallCodeSnippet(
      code: code,
      mode: 'shell',
    );
  }

  static AllnimallCodeSnippet dart({
    required String code,
  }) {
    return AllnimallCodeSnippet(
      code: code,
      mode: 'dart',
    );
  }

  static AllnimallCodeSnippet json({
    required String code,
  }) {
    return AllnimallCodeSnippet(
      code: code,
      mode: 'json',
    );
  }

  static AllnimallCodeSnippet sql({
    required String code,
  }) {
    return AllnimallCodeSnippet(
      code: code,
      mode: 'sql',
    );
  }

  static AllnimallCodeSnippet custom({
    required String code,
    required String mode,
  }) {
    return AllnimallCodeSnippet(
      code: code,
      mode: mode,
    );
  }
}
