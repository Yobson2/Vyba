import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Shows a themed confirmation/alert dialog.
///
/// Returns `true` if the user confirms, `false` or `null` otherwise.
Future<bool?> showAppDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmText = 'OK',
  String? cancelText = 'Cancel',
  bool isDestructive = false,
}) {
  final theme = Theme.of(context);
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderRadiusLg,
      ),
      title: Text(title),
      content: message != null ? Text(message) : null,
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText),
          ),
        AppSpacing.horizontalXs,
        ElevatedButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDestructive
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            foregroundColor: isDestructive
                ? theme.colorScheme.onError
                : theme.colorScheme.onPrimary,
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
