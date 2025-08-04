import 'package:shadcn_flutter/shadcn_flutter.dart';

class AllnimallAvatar extends StatelessWidget {
  final String? initials;
  final ImageProvider? provider;
  final Color? backgroundColor;
  final double size;
  final AvatarBadge? badge;

  const AllnimallAvatar({
    super.key,
    this.initials,
    this.provider,
    this.backgroundColor,
    this.size = 40,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Avatar(
      initials: initials != null ? Avatar.getInitials(initials!) : '',
      provider: provider,
      backgroundColor: backgroundColor,
      size: size,
      badge: badge,
    );
  }
}

class AllnimallAvatarBadge extends StatelessWidget {
  final double size;
  final Color color;
  final Widget? child;

  const AllnimallAvatarBadge({
    super.key,
    this.size = 20,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AvatarBadge(
      size: size,
      color: color,
      child: child,
    );
  }
}

// Helper class untuk membuat avatar dengan mudah
class AllnimallAvatarBuilder {
  static AllnimallAvatar user({
    required String name,
    String? imageUrl,
    double size = 40,
    Color? backgroundColor,
    AvatarBadge? badge,
  }) {
    return AllnimallAvatar(
      initials: name,
      provider: imageUrl != null ? NetworkImage(imageUrl) : null,
      backgroundColor: backgroundColor,
      size: size,
      badge: badge,
    );
  }

  static AllnimallAvatar withImage({
    required ImageProvider provider,
    double size = 40,
    AvatarBadge? badge,
  }) {
    return AllnimallAvatar(
      provider: provider,
      size: size,
      badge: badge,
    );
  }

  static AllnimallAvatar withInitials({
    required String initials,
    double size = 40,
    Color? backgroundColor,
    AvatarBadge? badge,
  }) {
    return AllnimallAvatar(
      initials: initials,
      backgroundColor: backgroundColor,
      size: size,
      badge: badge,
    );
  }
}
