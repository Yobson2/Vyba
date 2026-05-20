import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Outlined secondary button with optional icon.
class AppSecondaryButton extends StatelessWidget {
  /// Creates an [AppSecondaryButton].
  const AppSecondaryButton({
    required this.text,
    super.key,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
    this.height = 52,
  });

  /// Button label text.
  final String text;

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Optional leading icon.
  final IconData? icon;

  /// Shows a loading spinner and disables the button.
  final bool isLoading;

  /// Whether the button takes full width.
  final bool isExpanded;

  /// Button height.
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          side: BorderSide(color: theme.colorScheme.primary),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.primary,
                ),
              )
            : Row(
                mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    AppSpacing.horizontalSm,
                  ],
                  Text(text, style: theme.textTheme.labelLarge),
                ],
              ),
      ),
    );
  }
}
