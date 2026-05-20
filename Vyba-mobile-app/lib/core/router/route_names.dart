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

  static const String register = '/register';
  static const String registerName = 'register';

  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordName = 'forgotPassword';

  static const String otpVerification = '/otp-verification';
  static const String otpVerificationName = 'otpVerification';

  // -- Client Shell --
  static const String explore = '/explore';
  static const String exploreName = 'explore';

  static const String feed = '/feed';
  static const String feedName = 'feed';

  static const String clientBookings = '/bookings';
  static const String clientBookingsName = 'clientBookings';

  static const String clientProfile = '/client-profile';
  static const String clientProfileName = 'clientProfile';

  // -- Venue routes (nested under explore) --
  static const String venueDetail = 'venue/:venueId';
  static const String venueDetailName = 'venueDetail';

  static const String venueMenu = 'menu';
  static const String venueMenuName = 'venueMenu';

  static const String bookTable = 'book';
  static const String bookTableName = 'bookTable';

  static const String writeReview = 'review';
  static const String writeReviewName = 'writeReview';

  // -- Booking confirmation --
  static const String bookingConfirmation = ':bookingId/confirmation';
  static const String bookingConfirmationName = 'bookingConfirmation';

  // -- Search & Filter --
  static const String search = 'search';
  static const String searchName = 'search';

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

  static const String ownerBookings = '/owner/bookings';
  static const String ownerBookingsName = 'ownerBookings';

  static const String ownerPromos = '/owner/promos';
  static const String ownerPromosName = 'ownerPromos';

  static const String ownerProfile = '/owner/profile';
  static const String ownerProfileName = 'ownerProfile';

  // -- Owner sub-routes --
  static const String ownerAnalytics = 'analytics';
  static const String ownerAnalyticsName = 'ownerAnalytics';

  static const String myVenues = 'venues';
  static const String myVenuesName = 'myVenues';

  static const String editVenue = 'edit/:venueId';
  static const String editVenueName = 'editVenue';

  static const String createPromotion = 'create';
  static const String createPromotionName = 'createPromotion';

  // -- Legacy (kept for backward compatibility during migration) --
  static const String home = '/home';
  static const String homeName = 'home';

  static const String profile = '/profile';
  static const String profileName = 'profile';

  static const String notes = '/home/notes';
  static const String notesName = 'notes';

  static const String noteDetail = '/home/notes/detail';
  static const String noteDetailName = 'noteDetail';
}
