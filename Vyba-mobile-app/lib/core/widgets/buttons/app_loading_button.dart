import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';

/// Button with an integrated loading state.
///
/// When [isLoading] is true, shows a [CircularProgressIndicator]
/// instead of the [child] and disables interaction.
class AppLoadingButton extends StatelessWidget {
  /// Creates an [AppLoadingButton].
  const AppLoadingButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.isLoading = false,
    this.height = 52,
    this.isExpanded = true,
    this.backgroundColor,
  });

  /// Callback when pressed.
  final VoidCallback? onPressed;

  /// Button content when not loading.
  final Widget child;

  /// Whether the button is in loading state.
  final bool isLoading;

  /// Button height.
  final double height;

  /// Whether the button takes full width.
  final bool isExpanded;

  /// Optional background color override.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
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
            : child,
      ),
    );
  }
}
