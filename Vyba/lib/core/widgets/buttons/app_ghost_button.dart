import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Text-only ghost / link button.
class AppGhostButton extends StatelessWidget {
  /// Creates an [AppGhostButton].
  const AppGhostButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.color,
  });

  /// Button label text.
  final String text;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Custom text/icon color. Defaults to primary.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: effectiveColor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: effectiveColor),
            AppSpacing.horizontalXs,
          ],
          Text(text),
        ],
      ),
    );
  }
}
