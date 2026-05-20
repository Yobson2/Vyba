import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Snackbar variant types.
enum SnackBarVariant { success, error, warning, info }

/// Shows a themed snackbar with icon and color based on [variant].
void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackBarVariant variant = SnackBarVariant.info,
  Duration duration = const Duration(seconds: 3),
}) {
  final (color, icon) = switch (variant) {
    SnackBarVariant.success => (
        AppColors.success,
        Icons.check_circle,
      ),
    SnackBarVariant.error => (
        AppColors.error,
        Icons.error,
      ),
    SnackBarVariant.warning => (
        AppColors.warning,
        Icons.warning_amber,
      ),
    SnackBarVariant.info => (
        AppColors.info,
        Icons.info,
      ),
  };

  const foreground = Colors.white;

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: foreground, size: 20),
            AppSpacing.horizontalSm,
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: foreground),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        duration: duration,
        margin: AppSpacing.paddingLg,
      ),
    );
}
