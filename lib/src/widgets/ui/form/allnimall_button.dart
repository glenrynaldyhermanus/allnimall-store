import 'package:shadcn_flutter/shadcn_flutter.dart';

import 'package:allnimall_store/src/core/theme/app_theme.dart';

enum AllnimallButtonVariance {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
}

class AllnimallButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final AllnimallButtonVariance variance;

  const AllnimallButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.padding,
    this.borderRadius,
    this.variance = AllnimallButtonVariance.primary,
  });

  // Convenience constructors
  const AllnimallButton.primary({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.padding,
    this.borderRadius,
  }) : variance = AllnimallButtonVariance.primary;

  const AllnimallButton.secondary({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.padding,
    this.borderRadius,
  }) : variance = AllnimallButtonVariance.secondary;

  const AllnimallButton.outline({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.padding,
    this.borderRadius,
  }) : variance = AllnimallButtonVariance.outline;

  const AllnimallButton.ghost({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.padding,
    this.borderRadius,
  }) : variance = AllnimallButtonVariance.ghost;

  const AllnimallButton.destructive({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.padding,
    this.borderRadius,
  }) : variance = AllnimallButtonVariance.destructive;

  @override
  State<AllnimallButton> createState() => _AllnimallButtonState();
}

class _AllnimallButtonState extends State<AllnimallButton>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _hoverController;
  late AnimationController _shadowController;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _hoverAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));

    _hoverAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -2),
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOutCubic,
    ));

    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shadowController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _hoverController.dispose();
    _shadowController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      _bounceController.forward().then((_) {
        _bounceController.reverse();
      });
      widget.onPressed!();
    }
  }

  void _handleHover(bool isHovered) {
    if (isHovered) {
      _hoverController.forward();
      _shadowController.forward();
    } else {
      _hoverController.reverse();
      _shadowController.reverse();
    }
  }

  Color _getBackgroundColor() {
    switch (widget.variance) {
      case AllnimallButtonVariance.primary:
        return AppColors.primary;
      case AllnimallButtonVariance.secondary:
        return AppColors.secondary;
      case AllnimallButtonVariance.outline:
        return Colors.transparent;
      case AllnimallButtonVariance.ghost:
        return Colors.transparent;
      case AllnimallButtonVariance.destructive:
        return AppColors.error;
    }
  }

  Border? _getBorder() {
    switch (widget.variance) {
      case AllnimallButtonVariance.primary:
      case AllnimallButtonVariance.secondary:
      case AllnimallButtonVariance.ghost:
      case AllnimallButtonVariance.destructive:
        return null;
      case AllnimallButtonVariance.outline:
        return Border.all(
          color: AppColors.border,
          width: 1,
        );
    }
  }

  Color _getShadowColor() {
    switch (widget.variance) {
      case AllnimallButtonVariance.primary:
        return AppColors.primary;
      case AllnimallButtonVariance.secondary:
        return AppColors.secondary;
      case AllnimallButtonVariance.outline:
        return AppColors.border;
      case AllnimallButtonVariance.ghost:
        return AppColors.muted;
      case AllnimallButtonVariance.destructive:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: AnimatedBuilder(
        animation: Listenable.merge(
            [_bounceAnimation, _hoverAnimation, _shadowAnimation]),
        builder: (context, child) {
          return Transform.translate(
            offset: _hoverAnimation.value,
            child: Transform.scale(
              scale: _bounceAnimation.value,
              child: Container(
                width: widget.width,
                height: widget.height,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: _getBackgroundColor(),
                  border: _getBorder(),
                  borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
                  boxShadow: _shadowAnimation.value > 0
                      ? [
                          BoxShadow(
                            color: _getShadowColor().withValues(
                                alpha: 0.3 * _shadowAnimation.value),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: 2,
                          ),
                          BoxShadow(
                            color: _getShadowColor().withValues(
                                alpha: 0.2 * _shadowAnimation.value),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                            spreadRadius: 4,
                          ),
                        ]
                      : null,
                ),
                child: GestureDetector(
                  onTap: widget.onPressed != null ? _handleTap : null,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              onSurface: true,
                            ),
                          )
                        : widget.child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
