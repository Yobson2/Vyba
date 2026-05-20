import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_radius.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';

/// Shows a themed modal bottom sheet.
///
/// Returns the value passed to `Navigator.pop` by the [builder].
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
  bool isDismissible = true,
  bool isScrollControlled = true,
  bool useSafeArea = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(AppRadius.xl),
        topRight: Radius.circular(AppRadius.xl),
      ),
    ),
    builder: (ctx) => Padding(
      padding: AppSpacing.paddingLg,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(ctx).dividerColor,
              borderRadius: AppRadius.borderRadiusFull,
            ),
          ),
          builder(ctx),
        ],
      ),
    ),
  );
}
