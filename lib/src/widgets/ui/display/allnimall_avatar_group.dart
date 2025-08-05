import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallAvatarGroup extends StatelessWidget {
  final List<Avatar> children;
  final double spacing;
  final int? maxAvatars;
  final Alignment alignment;

  const AllnimallAvatarGroup({
    super.key,
    required this.children,
    this.spacing = 16,
    this.maxAvatars,
    this.alignment = Alignment.centerLeft,
  });

  @override
  Widget build(BuildContext context) {
    final avatars = maxAvatars != null && children.length > maxAvatars!
        ? children.take(maxAvatars!).toList()
        : children;

    return AvatarGroup(
      alignment: alignment,
      children: avatars,
    );
  }
}

// Helper class untuk membuat avatar group dengan mudah
class AllnimallAvatarGroupBuilder {
  static AllnimallAvatarGroup toLeft({
    required List<Avatar> children,
    double spacing = 16,
    int? maxAvatars,
  }) {
    return AllnimallAvatarGroup(
      spacing: spacing,
      maxAvatars: maxAvatars,
      alignment: Alignment.centerLeft,
      children: children,
    );
  }

  static AllnimallAvatarGroup toRight({
    required List<Avatar> children,
    double spacing = 16,
    int? maxAvatars,
  }) {
    return AllnimallAvatarGroup(
      spacing: spacing,
      maxAvatars: maxAvatars,
      alignment: Alignment.centerRight,
      children: children,
    );
  }

  static AllnimallAvatarGroup toTop({
    required List<Avatar> children,
    double spacing = 16,
    int? maxAvatars,
  }) {
    return AllnimallAvatarGroup(
      spacing: spacing,
      maxAvatars: maxAvatars,
      alignment: Alignment.topCenter,
      children: children,
    );
  }

  static AllnimallAvatarGroup toBottom({
    required List<Avatar> children,
    double spacing = 16,
    int? maxAvatars,
  }) {
    return AllnimallAvatarGroup(
      spacing: spacing,
      maxAvatars: maxAvatars,
      alignment: Alignment.bottomCenter,
      children: children,
    );
  }
}
