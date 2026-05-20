import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_effects.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Glassmorphic card with backdrop blur and translucent background.
///
/// Per design system: surfaceVariant at 60% opacity with 20px backdrop blur.
/// Includes a subtle top-edge border to simulate glass catching light.
class AppGlassCard extends StatelessWidget {
  const AppGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius,
    this.backgroundColor,
    this.blurAmount = AppBlur.medium,
  });

  final Widget child;
  final EdgeInsets padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double blurAmount;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = borderRadius ?? AppRadius.borderRadiusMd;
    return ClipRRect(
      borderRadius: effectiveRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurAmount,
          sigmaY: blurAmount,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassBg,
            borderRadius: effectiveRadius,
            border: const Border(
              top: BorderSide(
                color: Color(0x14FFFFFF), // white at ~8% — glass edge
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
