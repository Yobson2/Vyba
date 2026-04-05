import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_effects.dart';
import 'package:flutter_templates/core/theme/app_gradients.dart';
import 'package:flutter_templates/core/theme/app_motion.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_shadows.dart';

/// Primary CTA button with gradient fill (primary → primaryDim at 135°).
///
/// Includes a scale-down press animation and primary glow shadow.
class AppGradientButton extends StatefulWidget {
  const AppGradientButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.gradient,
    this.height = AppTouchTarget.button,
    this.width = double.infinity,
    this.borderRadius,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final Gradient? gradient;
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  @override
  State<AppGradientButton> createState() => _AppGradientButtonState();
}

class _AppGradientButtonState extends State<AppGradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.borderRadius ?? AppRadius.borderRadiusMd;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: AppMotion.fast,
        curve: AppMotion.defaultCurve,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.onPressed != null
                ? (widget.gradient ?? AppGradients.primaryButton)
                : null,
            color: widget.onPressed == null
                ? AppColors.surfaceContainerHigh
                : null,
            borderRadius: effectiveRadius,
            boxShadow: widget.onPressed != null ? AppShadows.primaryGlow : null,
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: AppIconSize.lg,
                    height: AppIconSize.lg,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.onPrimaryFixed,
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                            widget.icon,
                            color: AppColors.onPrimaryFixed,
                            size: AppIconSize.md,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.onPrimaryFixed,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
