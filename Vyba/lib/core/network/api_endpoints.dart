/// Static API endpoint path constants.
///
/// Centralizes all API routes in one place to avoid
/// hardcoded strings throughout the data layer.
class ApiEndpoints {
  const ApiEndpoints._();

  // -- Auth --
  static const String login = '/auth/login';
  static const String loginWithPhone = '/auth/login/phone';
  static const String loginWithGoogle = '/auth/login/google';
  static const String loginWithApple = '/auth/login/apple';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String updateRole = '/auth/role';

  // -- Venues --
  static const String venues = '/venues';
  static const String venueDetail = '/venues/{id}';
  static const String venueMenu = '/venues/{id}/menu';
  static const String venueReviews = '/venues/{id}/reviews';
  static const String venueEvents = '/venues/{id}/events';

  // -- Bookings --
  static const String bookings = '/bookings';
  static const String bookingDetail = '/bookings/{id}';
  static const String bookingSlots = '/bookings/slots';

  // -- Feed --
  static const String feed = '/feed';
  static const String promos = '/promos';
  static const String events = '/events';
  static const String eventInterest = '/events/{id}/interest';

  // -- Favorites --
  static const String favorites = '/favorites';
  static const String favoriteToggle = '/favorites/{venueId}';

  // -- Reviews --
  static const String reviews = '/reviews';

  // -- Search --
  static const String search = '/search';
  static const String trending = '/search/trending';

  // -- Notifications --
  static const String notifications = '/notifications';
  static const String notificationRead = '/notifications/{id}/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // -- Owner --
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerVenues = '/owner/venues';
  static const String ownerVenueDetail = '/owner/venues/{id}';
  static const String ownerBookings = '/owner/bookings';
  static const String ownerBookingConfirm = '/owner/bookings/{id}/confirm';
  static const String ownerBookingDecline = '/owner/bookings/{id}/decline';
  static const String ownerPromos = '/owner/promos';
  static const String ownerPromoDetail = '/owner/promos/{id}';
  static const String ownerAnalytics = '/owner/analytics';

  // -- Notes (legacy) --
  static const String notes = '/notes';
}
