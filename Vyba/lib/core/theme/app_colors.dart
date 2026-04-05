import 'package:flutter/material.dart';

/// Lagos Pulse design system color tokens.
///
/// Dark-first nightlife app palette based on "The Neon Curator" design system.
/// Boundaries are defined through tonal shifts, not borders (no-line rule).
class AppColors {
  const AppColors._();

  // ── Primary (Electric Indigo) ──────────────────────────────────

  /// Primary brand color — branding, active states, key icons.
  static const Color primary = Color(0xFFB0A3FF);

  /// Primary dimmed — moody late-night feel, gradient endpoint.
  static const Color primaryDim = Color(0xFF6C5CE7);

  /// Primary fixed — high-impact CTAs.
  static const Color primaryFixed = Color(0xFFA08CFF);

  /// Primary fixed dim.
  static const Color primaryFixedDim = Color(0xFF9080FF);

  /// Primary container.
  static const Color primaryContainer = Color(0xFF9396FF);

  /// On-primary — text/icons on primary surfaces.
  static const Color onPrimary = Color(0xFF0F00A4);

  /// On-primary fixed — text on primary CTA buttons.
  static const Color onPrimaryFixed = Color(0xFF000000);

  /// On-primary container.
  static const Color onPrimaryContainer = Color(0xFF0A0081);

  /// On-primary fixed variant.
  static const Color onPrimaryFixedVariant = Color(0xFF0E009D);

  /// Inverse primary.
  static const Color inversePrimary = Color(0xFF494BD7);

  // ── Secondary (Lagos Emerald — availability/success ONLY) ──────

  /// Secondary — availability, positive status signals.
  static const Color secondary = Color(0xFF69F6B8);

  /// Secondary dim.
  static const Color secondaryDim = Color(0xFF58E7AB);

  /// Secondary fixed.
  static const Color secondaryFixed = Color(0xFF69F6B8);

  /// Secondary fixed dim.
  static const Color secondaryFixedDim = Color(0xFF58E7AB);

  /// Secondary container.
  static const Color secondaryContainer = Color(0xFF006C49);

  /// On-secondary.
  static const Color onSecondary = Color(0xFF005A3C);

  /// On-secondary container.
  static const Color onSecondaryContainer = Color(0xFFE1FFEC);

  /// On-secondary fixed.
  static const Color onSecondaryFixed = Color(0xFF00452D);

  /// On-secondary fixed variant.
  static const Color onSecondaryFixedVariant = Color(0xFF006544);

  // ── Tertiary (Golden Hour — promos/VIP ONLY) ───────────────────

  /// Tertiary — promotions, VIP tiers, flash sales.
  static const Color tertiary = Color(0xFFFFB148);

  /// Tertiary dim.
  static const Color tertiaryDim = Color(0xFFE79400);

  /// Tertiary fixed — VIP/promo backgrounds.
  static const Color tertiaryFixed = Color(0xFFF8A010);

  /// Tertiary fixed dim.
  static const Color tertiaryFixedDim = Color(0xFFE79400);

  /// Tertiary container.
  static const Color tertiaryContainer = Color(0xFFF8A010);

  /// On-tertiary.
  static const Color onTertiary = Color(0xFF573500);

  /// On-tertiary container.
  static const Color onTertiaryContainer = Color(0xFF4A2C00);

  /// On-tertiary fixed.
  static const Color onTertiaryFixed = Color(0xFF2A1700);

  /// On-tertiary fixed variant.
  static const Color onTertiaryFixedVariant = Color(0xFF563400);

  // ── Error ──────────────────────────────────────────────────────

  /// Error color.
  static const Color error = Color(0xFFFF6E84);

  /// Error dim.
  static const Color errorDim = Color(0xFFD73357);

  /// Error container.
  static const Color errorContainer = Color(0xFFA70138);

  /// On-error.
  static const Color onError = Color(0xFF490013);

  /// On-error container.
  static const Color onErrorContainer = Color(0xFFFFB2B9);

  // ── Surfaces (Tonal Layering) ──────────────────────────────────

  /// Surface — the primary dark-mode canvas (Level 0).
  static const Color surface = Color(0xFF060E20);

  /// Surface dim.
  static const Color surfaceDim = Color(0xFF060E20);

  /// Surface bright.
  static const Color surfaceBright = Color(0xFF1F2B49);

  /// Surface tint.
  static const Color surfaceTint = Color(0xFFB0A3FF);

  /// Surface variant — glass panel base.
  static const Color surfaceVariant = Color(0xFF192540);

  /// Surface container lowest.
  static const Color surfaceContainerLowest = Color(0xFF000000);

  /// Surface container low (Level 1 — subtle grouping).
  static const Color surfaceContainerLow = Color(0xFF0C1A32);

  /// Surface container (Level 1.5).
  static const Color surfaceContainer = Color(0xFF111F3A);

  /// Surface container high (Level 2 — interactive cards).
  static const Color surfaceContainerHigh = Color(0xFF172742);

  /// Surface container highest — most prominent interactive elements.
  static const Color surfaceContainerHighest = Color(0xFF1D2F4C);

  /// Background.
  static const Color background = Color(0xFF060E20);

  // ── On-Surface ─────────────────────────────────────────────────

  /// On-surface — high-contrast body text.
  static const Color onSurface = Color(0xFFDEE5FF);

  /// On-surface variant — secondary text, metadata.
  static const Color onSurfaceVariant = Color(0xFFB0B7D0);

  /// On-background.
  static const Color onBackground = Color(0xFFDEE5FF);

  /// Inverse surface.
  static const Color inverseSurface = Color(0xFFFAF8FF);

  /// Inverse on-surface.
  static const Color inverseOnSurface = Color(0xFF4D556B);

  // ── Outline ────────────────────────────────────────────────────

  /// Outline — used sparingly for accessibility ghost borders.
  static const Color outline = Color(0xFF6D758C);

  /// Outline variant — ghost border at 15% opacity when needed.
  static const Color outlineVariant = Color(0xFF40485D);

  // ── Semantic (convenience aliases) ─────────────────────────────

  /// Warning color (uses tertiary).
  static const Color warning = Color(0xFFF8A010);

  /// Success color (uses secondary).
  static const Color success = Color(0xFF69F6B8);

  /// Info color — night-sky cyan.
  static const Color info = Color(0xFF38BDF8);

  // ── Pulse (brand accent — logo animations, "live now" ONLY) ───

  /// Neon magenta pulse — logo animations, live indicators.
  static const Color pulse = Color(0xFFFF2D78);

  /// Pulse dimmed.
  static const Color pulseDim = Color(0xFFD4175C);

  // ── Glass Panel ────────────────────────────────────────────────

  /// Glass panel background (60% opacity of surfaceVariant).
  static Color get glassBg => surfaceVariant.withValues(alpha: AppOpacity.glass);

  /// Glass panel background for light surfaces.
  static Color get glassBgLight =>
      const Color(0xFFFFFFFF).withValues(alpha: AppOpacity.glass);
}

/// Standardized opacity values for the Lagos Pulse design system.
///
/// Replaces scattered magic numbers across widgets.
class AppOpacity {
  const AppOpacity._();

  /// Shadow base.
  static const double subtle = 0.04;

  /// Hover states, soft shadows.
  static const double faint = 0.08;

  /// Disabled states.
  static const double light = 0.12;

  /// Dividers, ghost borders.
  static const double medium = 0.20;

  /// Glow effects, inactive indicators.
  static const double moderate = 0.30;

  /// Overlay masks.
  static const double semi = 0.50;

  /// Glassmorphism panels.
  static const double glass = 0.60;

  /// Scrim overlays.
  static const double heavy = 0.80;

  /// Near-opaque surfaces.
  static const double opaque = 0.95;
}
