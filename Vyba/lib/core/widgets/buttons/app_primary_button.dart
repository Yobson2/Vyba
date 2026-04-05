import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Primary filled button with optional icon and loading state.
///
/// Uses the primary color from the theme's [ColorScheme].
class AppPrimaryButton extends StatelessWidget {
  /// Creates an [AppPrimaryButton].
  const AppPrimaryButton({
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

  /// Callback when pressed. Disabled when `null` or [isLoading].
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
    return Semantics(
      button: true,
      enabled: !isLoading && onPressed != null,
      label: isLoading ? '$text, loading' : text,
      child: SizedBox(
        width: isExpanded ? double.infinity : null,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            disabledBackgroundColor: theme.colorScheme.primary.withValues(
              alpha: 0.6,
            ),
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
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Row(
                  mainAxisSize:
                      isExpanded ? MainAxisSize.max : MainAxisSize.min,
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
      ),
    );
  }
}
