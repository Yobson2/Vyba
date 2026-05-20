import 'package:flutter/material.dart';

/// Spacing tokens based on a 4px grid system.
///
/// Use these constants for all padding, margins, and gaps.
/// Never use hardcoded spacing values.
class AppSpacing {
  const AppSpacing._();

  /// 2px
  static const double xxs = 2;

  /// 4px
  static const double xs = 4;

  /// 8px
  static const double sm = 8;

  /// 12px
  static const double md = 12;

  /// 16px
  static const double lg = 16;

  /// 20px
  static const double lgx = 20;

  /// 24px
  static const double xl = 24;

  /// 32px
  static const double xxl = 32;

  /// 40px
  static const double xxxl = 40;

  /// 48px
  static const double xxxxl = 48;

  /// 56px — between content sections.
  static const double section = 56;

  /// 64px
  static const double jumbo = 64;

  /// 80px — hero/above-the-fold spacing.
  static const double hero = 80;

  // ── Semantic Aliases ───────────────────────────────────────────

  /// Gap between cards in a list (12px).
  static const double cardGap = md;

  /// Gap between content sections (40px).
  static const double sectionGap = xxxl;

  /// Screen edge horizontal padding (20px — iOS HIG).
  static const double screenPadding = lgx;

  // ── SizedBox Helpers ─────────────────────────────────────────

  /// Horizontal gap of 4px.
  static const SizedBox horizontalXs = SizedBox(width: xs);

  /// Horizontal gap of 8px.
  static const SizedBox horizontalSm = SizedBox(width: sm);

  /// Horizontal gap of 12px.
  static const SizedBox horizontalMd = SizedBox(width: md);

  /// Horizontal gap of 16px.
  static const SizedBox horizontalLg = SizedBox(width: lg);

  /// Horizontal gap of 24px.
  static const SizedBox horizontalXl = SizedBox(width: xl);

  /// Horizontal gap of 32px.
  static const SizedBox horizontalXxl = SizedBox(width: xxl);

  /// Vertical gap of 4px.
  static const SizedBox verticalXs = SizedBox(height: xs);

  /// Vertical gap of 8px.
  static const SizedBox verticalSm = SizedBox(height: sm);

  /// Vertical gap of 12px.
  static const SizedBox verticalMd = SizedBox(height: md);

  /// Vertical gap of 16px.
  static const SizedBox verticalLg = SizedBox(height: lg);

  /// Vertical gap of 24px.
  static const SizedBox verticalXl = SizedBox(height: xl);

  /// Vertical gap of 32px.
  static const SizedBox verticalXxl = SizedBox(height: xxl);

  /// Vertical gap of 48px.
  static const SizedBox verticalXxxl = SizedBox(height: xxxxl);

  // ── EdgeInsets Helpers ────────────────────────────────────────

  /// All-sides padding of 8px.
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// All-sides padding of 12px.
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// All-sides padding of 16px.
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// All-sides padding of 24px.
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Horizontal padding of 16px.
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal padding of 24px.
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: xl);

  /// Screen edge padding (20px horizontal).
  static const EdgeInsets paddingScreen =
      EdgeInsets.symmetric(horizontal: screenPadding);

  /// Vertical gap of 56px (section separator).
  static const SizedBox verticalSection = SizedBox(height: section);

  /// Vertical gap of 80px (hero spacing).
  static const SizedBox verticalHero = SizedBox(height: hero);
}
