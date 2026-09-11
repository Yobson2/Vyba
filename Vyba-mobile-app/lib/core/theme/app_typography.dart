import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Vyba typography tokens using a dual-font strategy.
///
/// - **Epilogue**: Headlines & display — geometric weight with editorial personality.
/// - **Inter**: Body & labels — clean modern clarity for dense information.
/// - **Space Mono**: Accent numerals — prices, countdowns, table counts.
class AppTypography {
  const AppTypography._();

  static String get _headlineFont => GoogleFonts.epilogue().fontFamily!;
  static String get _bodyFont => GoogleFonts.inter().fontFamily!;
  static String get _accentFont => GoogleFonts.spaceMono().fontFamily!;

  // ── Dark Text Theme (primary — dark-first app) ─────────────────

  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 57,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02 * 57, // -1.14
          color: AppColors.onSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.03 * 45, // -1.35
          color: AppColors.onSurface,
        ),
        displaySmall: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 36, // -0.72
          color: AppColors.onSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        headlineSmall: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleLarge: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        titleMedium: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: AppColors.onSurface,
        ),
        titleSmall: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: AppColors.onSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.5,
          color: AppColors.onSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.5,
          color: AppColors.onSurface,
        ),
        bodySmall: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.4,
          color: AppColors.onSurfaceVariant,
        ),
        labelLarge: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.2,
          color: AppColors.onSurface,
        ),
        labelMedium: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.onSurfaceVariant,
        ),
        labelSmall: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.onSurfaceVariant,
        ),
      );

  // ── Light Text Theme ───────────────────────────────────────────

  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 57,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.02 * 57, // -1.14
          color: AppColors.inverseSurface,
        ),
        displayMedium: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.03 * 45, // -1.35
          color: AppColors.inverseSurface,
        ),
        displaySmall: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.02 * 36, // -0.72
          color: AppColors.inverseSurface,
        ),
        headlineLarge: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.inverseSurface,
        ),
        headlineMedium: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.inverseSurface,
        ),
        headlineSmall: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.inverseSurface,
        ),
        titleLarge: TextStyle(
          fontFamily: _headlineFont,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.inverseSurface,
        ),
        titleMedium: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          color: AppColors.inverseSurface,
        ),
        titleSmall: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: AppColors.inverseSurface,
        ),
        bodyLarge: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.5,
          color: AppColors.inverseSurface,
        ),
        bodyMedium: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.5,
          color: AppColors.inverseSurface,
        ),
        bodySmall: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.4,
          color: AppColors.inverseOnSurface,
        ),
        labelLarge: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.2,
          color: AppColors.inverseSurface,
        ),
        labelMedium: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.inverseOnSurface,
        ),
        labelSmall: TextStyle(
          fontFamily: _bodyFont,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.inverseOnSurface,
        ),
      );

  // ── Accent Text Styles ─────────────────────────────────────────

  /// Monospace accent for prices (e.g. 12 500 FCFA).
  static TextStyle get priceDisplay => TextStyle(
        fontFamily: _accentFont,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.onSurface,
      );

  /// Monospace accent for countdown timers.
  static TextStyle get countdownDisplay => TextStyle(
        fontFamily: _accentFont,
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: AppColors.tertiary,
      );

  /// Italic editorial style for venue taglines and promo copy.
  static TextStyle get featureTagline => TextStyle(
        fontFamily: _headlineFont,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        letterSpacing: 0.5,
        color: AppColors.onSurface,
      );
}
