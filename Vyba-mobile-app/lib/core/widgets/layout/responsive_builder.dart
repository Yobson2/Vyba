import 'package:flutter/material.dart';

/// Breakpoint thresholds.
class Breakpoints {
  const Breakpoints._();

  /// Mobile max width.
  static const double mobile = 600;

  /// Tablet max width.
  static const double tablet = 1024;
}

/// Builds different layouts based on screen width breakpoints.
///
/// Provides [mobile] layout (< 600px) and [tablet] layout (>= 600px).
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a [ResponsiveBuilder].
  const ResponsiveBuilder({
    required this.mobile,
    super.key,
    this.tablet,
  });

  /// Widget for mobile screens.
  final Widget mobile;

  /// Widget for tablet screens. Falls back to [mobile] if null.
  final Widget? tablet;

  /// Whether the current screen is a tablet.
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.mobile;

  /// Whether the current screen is a desktop.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= Breakpoints.mobile && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}
