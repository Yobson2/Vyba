import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Error state placeholder with retry button.
class AppErrorState extends StatelessWidget {
  /// Creates an [AppErrorState].
  const AppErrorState({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
    this.retryText = 'Retry',
    this.icon = Icons.error_outline,
    this.iconSize = 64,
  });

  /// Error message.
  final String message;

  /// Callback for the retry button.
  final VoidCallback? onRetry;

  /// Retry button text.
  final String retryText;

  /// Error icon.
  final IconData icon;

  /// Size of the icon.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      label: message,
      child: Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: theme.colorScheme.error,
              ),
              AppSpacing.verticalLg,
              Text(
                message,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                AppSpacing.verticalXl,
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: Text(retryText),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
