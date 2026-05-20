import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Header widget for auth pages with title and subtitle.
class AuthHeader extends StatelessWidget {
  /// Creates an [AuthHeader].
  const AuthHeader({
    required this.title,
    super.key,
    this.subtitle,
  });

  /// Main title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.verticalXl,
        Icon(
          Icons.flutter_dash,
          size: 48,
          color: theme.colorScheme.primary,
        ),
        AppSpacing.verticalXl,
        Text(title, style: theme.textTheme.headlineMedium),
        if (subtitle != null) ...[
          AppSpacing.verticalSm,
          Text(
            subtitle!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
        AppSpacing.verticalXxl,
      ],
    );
  }
}
