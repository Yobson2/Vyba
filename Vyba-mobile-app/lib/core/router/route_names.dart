/// Static route name and path constants.
abstract final class RouteNames {
  // -- Splash --
  static const String splash = '/';
  static const String splashName = 'splash';

  // -- Onboarding --
  static const String onboarding = '/onboarding';
  static const String onboardingName = 'onboarding';

  // -- Role Selection --
  static const String roleSelection = '/role-selection';
  static const String roleSelectionName = 'roleSelection';

  // -- Auth --
  static const String login = '/login';
  static const String loginName = 'login';

  static const String otpVerification = '/otp-verification';
  static const String otpVerificationName = 'otpVerification';

  // -- Client Shell --
  static const String explore = '/explore';
  static const String exploreName = 'explore';

  static const String feed = '/feed';
  static const String feedName = 'feed';

  static const String clientProfile = '/client-profile';
  static const String clientProfileName = 'clientProfile';

  // -- Venue routes (nested under explore) --
  static const String venueDetail = 'venue/:venueId';
  static const String venueDetailName = 'venueDetail';

  // -- Favorites --
  static const String favorites = 'favorites';
  static const String favoritesName = 'favorites';

  // -- Notifications --
  static const String notifications = 'notifications';
  static const String notificationsName = 'notifications';

  // -- Settings --
  static const String settings = 'settings';
  static const String settingsName = 'settings';

  // -- Owner Shell --
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerDashboardName = 'ownerDashboard';

  static const String ownerPromos = '/owner/promos';
  static const String ownerPromosName = 'ownerPromos';

  static const String ownerProfile = '/owner/profile';
  static const String ownerProfileName = 'ownerProfile';

  // -- Owner sub-routes --
  static const String createPromotion = 'create';
  static const String createPromotionName = 'createPromotion';

  // -- Legacy (kept for backward compatibility during migration) --
  static const String home = '/home';
  static const String homeName = 'home';

  static const String profile = '/profile';
  static const String profileName = 'profile';
}
