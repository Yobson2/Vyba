import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Banner displayed when the device has no network connectivity.
class AppOfflineBanner extends StatelessWidget {
  /// Creates an [AppOfflineBanner].
  const AppOfflineBanner({super.key, this.message});

  /// Override message text. Defaults to 'You are offline'.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayMessage = message ?? 'You are offline';
    return Semantics(
      liveRegion: true,
      label: displayMessage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.lg,
        ),
        color: theme.colorScheme.error,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 16,
              color: theme.colorScheme.onError,
            ),
            AppSpacing.horizontalSm,
            Text(
              displayMessage,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
