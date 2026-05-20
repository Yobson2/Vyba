import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Overlay-based toast notification.
///
/// Displays a brief message that auto-dismisses.
class AppToast {
  const AppToast._();

  static OverlayEntry? _currentEntry;
  static Timer? _timer;

  /// Shows a toast message at the top of the screen.
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    IconData? icon,
  }) {
    _dismiss();
    final overlay = Overlay.of(context);
    final theme = Theme.of(context);

    _currentEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.inverseSurface,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon,
                      color: theme.colorScheme.onInverseSurface, size: 20),
                  AppSpacing.horizontalSm,
                ],
                Expanded(
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onInverseSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_currentEntry!);
    _timer = Timer(duration, _dismiss);
  }

  static void _dismiss() {
    _timer?.cancel();
    _timer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}
