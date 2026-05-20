import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Empty state placeholder with icon, title, subtitle, and action.
class AppEmptyState extends StatelessWidget {
  /// Creates an [AppEmptyState].
  const AppEmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'Nothing here yet',
    this.subtitle,
    this.actionText,
    this.onAction,
    this.iconSize = 64,
  });

  /// Large icon displayed at the top.
  final IconData icon;

  /// Title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional action button text.
  final String? actionText;

  /// Callback for the action button.
  final VoidCallback? onAction;

  /// Size of the icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: subtitle != null ? '$title. $subtitle' : title,
      child: Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: theme.colorScheme.outline,
              ),
              AppSpacing.verticalLg,
              Text(
                title,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                AppSpacing.verticalSm,
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (actionText != null && onAction != null) ...[
                AppSpacing.verticalXl,
                OutlinedButton(
                  onPressed: onAction,
                  child: Text(actionText!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
