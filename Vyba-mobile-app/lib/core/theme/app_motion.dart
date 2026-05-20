import 'package:flutter/widgets.dart';

/// Animation and motion tokens for the Vyba design system.
///
/// Standardizes durations and curves across all widgets.
/// Respects reduced-motion accessibility preferences via [resolve].
class AppMotion {
  const AppMotion._();

  // ── Durations ──────────────────────────────────────────────────────

  /// Micro-interactions: ripples, icon state changes.
  static const Duration instant = Duration(milliseconds: 100);

  /// Quick feedback: chip selection, toggle, color change.
  static const Duration fast = Duration(milliseconds: 200);

  /// Standard transitions: card expand, page fade, tab switch.
  static const Duration normal = Duration(milliseconds: 300);

  /// Emphasized transitions: modal enter, bottom sheet, success anim.
  static const Duration slow = Duration(milliseconds: 450);

  /// Dramatic transitions: onboarding, first-launch, hero animations.
  static const Duration dramatic = Duration(milliseconds: 600);

  /// Stagger delay between list items for staggered entrance animations.
  static const Duration staggerDelay = Duration(milliseconds: 50);

  // ── Page Transition Presets ────────────────────────────────────────

  /// Default page transition duration.
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// Default page transition curve.
  static const Curve pageCurve = Curves.easeOutCubic;

  // ── Curves ─────────────────────────────────────────────────────────

  /// Default ease for most transitions.
  static const Curve defaultCurve = Curves.easeOutCubic;

  /// Enter/appear animations (element appearing on screen).
  static const Curve enterCurve = Curves.easeOutQuart;

  /// Exit/dismiss animations.
  static const Curve exitCurve = Curves.easeInCubic;

  /// Spring/bounce for success, celebrations, confirmations.
  static const Curve bounceCurve = Curves.elasticOut;

  /// Deceleration for scroll-to-stop, carousel settle.
  static const Curve decelerateCurve = Curves.decelerate;

  /// Emphasized ease for dramatic reveals.
  static const Curve emphasizedCurve = Cubic(0.2, 0, 0, 1);

  // ── Accessibility ──────────────────────────────────────────────────

  /// Returns [Duration.zero] when the platform requests reduced motion,
  /// otherwise returns the given [duration].
  static Duration resolve(BuildContext context, Duration duration) {
    if (MediaQuery.of(context).disableAnimations) return Duration.zero;
    return duration;
  }

  /// Returns a static curve (no animation) when reduced motion is requested.
  static Curve resolveCurve(BuildContext context, Curve curve) {
    if (MediaQuery.of(context).disableAnimations) return Curves.linear;
    return curve;
  }
}
