import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Themed list tile with leading and trailing support.
class AppListTile extends StatelessWidget {
  /// Creates an [AppListTile].
  const AppListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.dense = false,
    this.showDivider = false,
  });

  /// Title text.
  final String title;

  /// Subtitle text.
  final String? subtitle;

  /// Leading widget (icon/avatar).
  final Widget? leading;

  /// Trailing widget (icon/switch).
  final Widget? trailing;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Whether to use compact sizing.
  final bool dense;

  /// Whether to show a bottom divider.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(title, style: theme.textTheme.bodyLarge),
          subtitle: subtitle != null
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xxs),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall,
                  ),
                )
              : null,
          leading: leading,
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
          dense: dense,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
          ),
        ),
        if (showDivider) const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
