import 'package:flutter/material.dart';

/// Themed progress indicator (circular or linear).
class AppProgress extends StatelessWidget {
  /// Creates a circular [AppProgress].
  const AppProgress({
    super.key,
    this.size = 32,
    this.strokeWidth = 3,
    this.color,
  })  : _isLinear = false,
        _value = null;

  /// Creates a linear [AppProgress].
  const AppProgress.linear({
    super.key,
    this.color,
    double? value,
  })  : _isLinear = true,
        _value = value,
        size = 0,
        strokeWidth = 0;

  /// Size of the circular indicator.
  final double size;

  /// Stroke width of the circular indicator.
  final double strokeWidth;

  /// Color override. Defaults to primary.
  final Color? color;

  final bool _isLinear;
  final double? _value;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    if (_isLinear) {
      return LinearProgressIndicator(
        value: _value,
        color: effectiveColor,
        backgroundColor: effectiveColor.withValues(alpha: 0.2),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: effectiveColor,
      ),
    );
  }
}
