import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder for loading states.
class AppShimmer extends StatelessWidget {
  /// Creates an [AppShimmer].
  const AppShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
    this.child,
  });

  /// Width of the shimmer box.
  final double width;

  /// Height of the shimmer box.
  final double height;

  /// Border radius. Defaults to [AppRadius.borderRadiusSm].
  final BorderRadius? borderRadius;

  /// Custom child widget. If provided, wraps it in shimmer effect.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = theme.colorScheme.surfaceContainerHighest;
    return Shimmer.fromColors(
      baseColor: isDark ? surfaceColor : Colors.grey[300]!,
      highlightColor:
          isDark ? surfaceColor.withValues(alpha: 0.5) : Colors.grey[100]!,
      child: child ??
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: borderRadius ?? AppRadius.borderRadiusSm,
            ),
          ),
    );
  }
}
