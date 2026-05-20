import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';

/// Box shadow tokens for elevation effects.
///
/// Uses tinted shadows with on_surface color instead of pure black.
/// For floating elements, uses soft ambient shadows with large blur.
class AppShadows {
  const AppShadows._();

  // ── Ambient Shadows (tinted with on_surface) ───────────────────

  /// Small shadow for subtle elevation (cards).
  static List<BoxShadow> get sm => [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: AppOpacity.subtle),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: AppOpacity.subtle + 0.02),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Medium shadow for elevated components.
  static List<BoxShadow> get md => [
        BoxShadow(
          color:
              AppColors.onSurface.withValues(alpha: AppOpacity.subtle + 0.02),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: AppOpacity.faint),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  /// Large shadow for floating components (dialogs, sheets).
  static List<BoxShadow> get lg => [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: AppOpacity.faint),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: AppOpacity.light),
          blurRadius: 32,
          offset: const Offset(0, 16),
        ),
      ];

  // ── Floating Element Shadow ────────────────────────────────────

  /// Floating shadow for prominent CTAs (e.g. "Book Table" sticky button).
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: AppColors.onSurface.withValues(alpha: AppOpacity.faint),
          blurRadius: 24,
          spreadRadius: -4,
        ),
      ];

  // ── Standard Glow Effects ──────────────────────────────────────

  /// Primary glow for active/highlighted elements.
  static List<BoxShadow> get primaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: AppOpacity.moderate),
          blurRadius: 16,
          spreadRadius: -2,
        ),
      ];

  /// Secondary glow for availability/success highlights.
  static List<BoxShadow> get secondaryGlow => [
        BoxShadow(
          color: AppColors.secondary.withValues(alpha: AppOpacity.moderate),
          blurRadius: 16,
          spreadRadius: -2,
        ),
      ];

  /// Tertiary glow for VIP/promo highlights.
  static List<BoxShadow> get tertiaryGlow => [
        BoxShadow(
          color: AppColors.tertiaryFixed.withValues(alpha: AppOpacity.moderate),
          blurRadius: 16,
          spreadRadius: -2,
        ),
      ];

  // ── Neon Glow Effects (hero moments) ───────────────────────────

  /// Intensified primary neon glow for featured venues, booking confirmation.
  static List<BoxShadow> get neonPrimaryGlow => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: AppOpacity.semi),
          blurRadius: 32,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: AppColors.primary.withValues(alpha: AppOpacity.medium),
          blurRadius: 64,
          spreadRadius: -8,
        ),
      ];

  /// Intensified tertiary neon glow for VIP / promo hero moments.
  static List<BoxShadow> get neonTertiaryGlow => [
        BoxShadow(
          color: AppColors.tertiaryFixed.withValues(alpha: AppOpacity.semi),
          blurRadius: 32,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: AppColors.tertiaryFixed.withValues(alpha: AppOpacity.medium),
          blurRadius: 64,
          spreadRadius: -8,
        ),
      ];

  /// Pulse neon glow for "Live Now" indicators.
  static List<BoxShadow> get neonPulseGlow => [
        BoxShadow(
          color: AppColors.pulse.withValues(alpha: AppOpacity.semi),
          blurRadius: 32,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: AppColors.pulse.withValues(alpha: AppOpacity.medium),
          blurRadius: 64,
          spreadRadius: -8,
        ),
      ];
}
