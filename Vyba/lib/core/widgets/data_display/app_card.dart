import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Themed card with optional header and footer.
class AppCard extends StatelessWidget {
  /// Creates an [AppCard].
  const AppCard({
    required this.child,
    super.key,
    this.header,
    this.footer,
    this.padding,
    this.onTap,
    this.borderColor,
  });

  /// Card body content.
  final Widget child;

  /// Optional header widget above body.
  final Widget? header;

  /// Optional footer widget below body.
  final Widget? footer;

  /// Content padding. Defaults to [AppSpacing.paddingLg].
  final EdgeInsetsGeometry? padding;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Optional border color override.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color ?? theme.colorScheme.surface,
          borderRadius: AppRadius.borderRadiusMd,
          border: Border.all(
            color: borderColor ?? theme.dividerColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (header != null) ...[
              Padding(
                padding: AppSpacing.paddingLg,
                child: header,
              ),
              Divider(height: 1, color: theme.dividerColor),
            ],
            Padding(
              padding: padding ?? AppSpacing.paddingLg,
              child: child,
            ),
            if (footer != null) ...[
              Divider(height: 1, color: theme.dividerColor),
              Padding(
                padding: AppSpacing.paddingLg,
                child: footer,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
