/// Blur, icon sizing, and touch target tokens for the Lagos Pulse design system.
///
/// Centralizes values that were previously scattered as magic numbers
/// across widgets.
class AppBlur {
  const AppBlur._();

  /// Light frosted effect.
  static const double subtle = 4;

  /// Chips, small overlays.
  static const double light = 10;

  /// Glass cards, floating panels.
  static const double medium = 20;

  /// Full-screen overlays, modals.
  static const double heavy = 40;

  /// Background blur behind sheets.
  static const double extreme = 60;
}

/// Standardized icon sizes aligned with the typography scale.
class AppIconSize {
  const AppIconSize._();

  /// Inline with labelSmall (14px).
  static const double xs = 14;

  /// Inline with body text (16px).
  static const double sm = 16;

  /// Button icons, list leading (20px).
  static const double md = 20;

  /// Standard Material icon (24px).
  static const double lg = 24;

  /// Section headers, nav (32px).
  static const double xl = 32;

  /// Empty states, feature icons (40px).
  static const double xxl = 40;

  /// Onboarding, splash (56px).
  static const double hero = 56;
}

/// Minimum touch target sizes per WCAG / Material guidelines.
class AppTouchTarget {
  const AppTouchTarget._();

  /// WCAG minimum touch target.
  static const double minimum = 44;

  /// Standard button height.
  static const double button = 52;

  /// Compact touch target (icon buttons in dense layouts).
  static const double compact = 36;

  /// Navigation bar item.
  static const double navItem = 48;
}
