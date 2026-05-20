import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/layout/responsive_builder.dart';

/// Applies responsive horizontal padding based on screen size.
///
/// Uses larger padding on tablet screens for comfortable reading.
class AppResponsivePadding extends StatelessWidget {
  /// Creates an [AppResponsivePadding].
  const AppResponsivePadding({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveBuilder.isTablet(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? AppSpacing.xxxl : AppSpacing.lg,
      ),
      child: child,
    );
  }
}
