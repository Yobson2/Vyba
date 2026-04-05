import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';

/// Gradient tokens for the Vyba design system.
///
/// All primary CTAs use gradient fills. Image cards use scrim overlays.
/// Floating headers use glassmorphic gradients.
class AppGradients {
  const AppGradients._();

  /// Primary button gradient — 135° from primary to primaryDim.
  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment(-0.7, -0.7),
    end: Alignment(0.7, 0.7),
    colors: [AppColors.primary, AppColors.primaryDim],
  );

  /// Tertiary promotional gradient for featured events.
  static const LinearGradient tertiaryPromo = LinearGradient(
    begin: Alignment(-0.7, -0.7),
    end: Alignment(0.7, 0.7),
    colors: [AppColors.tertiaryFixed, AppColors.tertiaryDim],
  );

  /// Scrim overlay — bottom-to-top black fade for image cards.
  static const LinearGradient scrimOverlay = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color(0xCC000000),
      Color(0x66000000),
      Color(0x00000000),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  /// Light scrim for image cards with text at bottom only.
  static const LinearGradient scrimBottom = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [
      Color(0xBB000000),
      Color(0x00000000),
    ],
  );

  /// Glassmorphic header — top-down fade for floating headers.
  static const LinearGradient glassmorphicHeader = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x800F172A),
      Color(0x000F172A),
    ],
  );

  // ── Nightlife Gradients ────────────────────────────────────────

  /// VIP gold gradient for exclusive badges and tier labels.
  static const LinearGradient vipGold = LinearGradient(
    begin: Alignment(-0.7, -0.7),
    end: Alignment(0.7, 0.7),
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
  );

  /// Heat gradient — venue popularity/energy level indicator.
  static const LinearGradient heatGradient = LinearGradient(
    colors: [
      AppColors.pulse,
      Color(0xFFFF6B3D),
      AppColors.tertiary,
    ],
  );

  /// Subtle primary tint for featured venue card backgrounds.
  static const LinearGradient surfaceGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x0DB0A3FF), // primary at ~5%
      Color(0x00000000),
    ],
  );

  /// Deep night sky ambient background gradient.
  static const LinearGradient nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0A0F1E),
      AppColors.surface,
    ],
  );

  /// Availability glow for "Open Now" and available status.
  static const LinearGradient availableGlow = LinearGradient(
    begin: Alignment(-0.7, -0.7),
    end: Alignment(0.7, 0.7),
    colors: [AppColors.secondary, AppColors.secondaryDim],
  );
}
