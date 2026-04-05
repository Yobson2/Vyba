import 'package:flutter/services.dart';

/// Semantic haptic feedback for premium interactions.
///
/// Wraps [HapticFeedback] with named methods that map to
/// Vyba interaction patterns.
class AppHaptics {
  const AppHaptics._();

  /// Light tap — tab selection, chip toggle, filter change.
  static Future<void> light() => HapticFeedback.lightImpact();

  /// Medium tap — booking step complete, carousel snap, toggle.
  static Future<void> medium() => HapticFeedback.mediumImpact();

  /// Heavy tap — booking confirmed, QR generated.
  static Future<void> heavy() => HapticFeedback.heavyImpact();

  /// Selection tick — picker scroll, stepper increment.
  static Future<void> selection() => HapticFeedback.selectionClick();

  /// Success vibration — VIP badge earned, review submitted.
  static Future<void> success() => HapticFeedback.mediumImpact();

  /// Warning vibration — last table available, error state.
  static Future<void> warning() => HapticFeedback.heavyImpact();
}
