import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallSkeleton extends StatelessWidget {
  final Widget child;

  const AllnimallSkeleton({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child.asSkeleton();
  }
}

// Helper class untuk membuat skeleton dengan mudah
class AllnimallSkeletonBuilder {
  static AllnimallSkeleton basic({
    required Widget child,
  }) {
    return AllnimallSkeleton(child: child);
  }

  static AllnimallSkeleton text({
    required String text,
    TextStyle? style,
  }) {
    return AllnimallSkeleton(
      child: Text(text, style: style),
    );
  }

  static AllnimallSkeleton card({
    required Widget title,
    required Widget content,
    Widget? leading,
    Widget? trailing,
  }) {
    return AllnimallSkeleton(
      child: Basic(
        title: title,
        content: content,
        leading: leading,
        trailing: trailing,
      ),
    );
  }

  static AllnimallSkeleton avatar({
    required String initials,
    double size = 40,
  }) {
    return AllnimallSkeleton(
      child: Avatar(
        initials: initials,
        size: size,
      ),
    );
  }

  static AllnimallSkeleton button({
    required String text,
    ButtonStyle? style,
  }) {
    return AllnimallSkeleton(
      child: PrimaryButton(
        child: Text(text),
        onPressed: () {},
      ),
    );
  }
} 