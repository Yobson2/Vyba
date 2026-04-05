import 'package:flutter/material.dart';

/// Border radius tokens for the design system.
///
/// Use these for all rounded corners throughout the app.
class AppRadius {
  const AppRadius._();

  /// 4px radius.
  static const double xs = 4;

  /// 8px radius.
  static const double sm = 8;

  /// 12px radius.
  static const double md = 12;

  /// 16px radius.
  static const double lg = 16;

  /// 24px radius.
  static const double xl = 24;

  /// Fully rounded (pill shape).
  static const double full = 999;

  // ── BorderRadius Helpers ─────────────────────────────────────

  /// [BorderRadius] of 4px.
  static BorderRadius get borderRadiusXs =>
      const BorderRadius.all(Radius.circular(xs));

  /// [BorderRadius] of 8px.
  static BorderRadius get borderRadiusSm =>
      const BorderRadius.all(Radius.circular(sm));

  /// [BorderRadius] of 12px.
  static BorderRadius get borderRadiusMd =>
      const BorderRadius.all(Radius.circular(md));

  /// [BorderRadius] of 16px.
  static BorderRadius get borderRadiusLg =>
      const BorderRadius.all(Radius.circular(lg));

  /// [BorderRadius] of 24px.
  static BorderRadius get borderRadiusXl =>
      const BorderRadius.all(Radius.circular(xl));

  /// Fully rounded [BorderRadius].
  static BorderRadius get borderRadiusFull =>
      const BorderRadius.all(Radius.circular(full));
}
