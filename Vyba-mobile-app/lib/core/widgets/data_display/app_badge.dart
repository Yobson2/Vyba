import 'package:flutter/material.dart';

/// Notification count badge overlay.
///
/// Wraps a [child] and shows a count badge in the top-right corner.
class AppBadge extends StatelessWidget {
  /// Creates an [AppBadge].
  const AppBadge({
    required this.child,
    super.key,
    this.count = 0,
    this.showZero = false,
    this.color,
    this.textColor,
    this.maxCount = 99,
  });

  /// The widget to overlay the badge on.
  final Widget child;

  /// Badge count.
  final int count;

  /// Whether to show the badge when count is 0.
  final bool showZero;

  /// Badge background color. Defaults to error color.
  final Color? color;

  /// Badge text color. Defaults to on-error color.
  final Color? textColor;

  /// Maximum count to display (shows "99+" beyond).
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    if (count <= 0 && !showZero) return child;

    final theme = Theme.of(context);
    final displayText = count > maxCount ? '$maxCount+' : '$count';

    return Semantics(
      label: '$count notification${count == 1 ? '' : 's'}',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: color ?? theme.colorScheme.error,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                displayText,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: textColor ?? theme.colorScheme.onError,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
