import 'package:flutter/material.dart';

/// Widget utility extensions.
extension WidgetX on Widget {
  /// Wraps this widget in [Padding] with the given [padding].
  Widget padded(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: this,
      );

  /// Wraps in all-sides padding.
  Widget paddedAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  /// Wraps in symmetric padding.
  Widget paddedSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  /// Wraps in only-side padding.
  Widget paddedOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(
          left: left,
          top: top,
          right: right,
          bottom: bottom,
        ),
        child: this,
      );

  /// Centers this widget.
  Widget centered() => Center(child: this);

  /// Wraps in [Expanded] with optional [flex].
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Wraps in [Flexible] with optional [flex].
  Widget flexible({int flex = 1}) => Flexible(flex: flex, child: this);

  /// Wraps in [SliverToBoxAdapter].
  Widget get asSliver => SliverToBoxAdapter(child: this);

  /// Wraps in [GestureDetector] with [onTap].
  Widget onTap(VoidCallback? onTap) => GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: this,
      );

  /// Wraps in [Opacity] widget.
  Widget withOpacity(double opacity) => Opacity(
        opacity: opacity,
        child: this,
      );

  /// Wraps in [SafeArea].
  Widget get safeArea => SafeArea(child: this);

  /// Wraps in [SizedBox] with given dimensions.
  Widget sized({double? width, double? height}) => SizedBox(
        width: width,
        height: height,
        child: this,
      );
}
