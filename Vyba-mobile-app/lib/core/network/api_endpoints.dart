/// Static API endpoint path constants.
///
/// Centralizes all API routes in one place to avoid
/// hardcoded strings throughout the data layer.
class ApiEndpoints {
  const ApiEndpoints._();

  // -- Auth (phone-OTP, ADR-0003) --
  static const String requestOtp = '/api/auth/request-code';
  static const String verifyOtp = '/api/auth/verify-code';
  static const String refreshToken = '/api/auth/refresh';

  // -- Venues --
  static const String venues = '/venues';
  static const String venueDetail = '/venues/{id}';
  static const String venueReviews = '/venues/{id}/reviews';
  static const String venueEvents = '/venues/{id}/events';

  // -- Venue detail + tonight (real backend; ticket 06) --
  static const String venueDetailWithTonight = '/api/venues/{id}/detail';
  static const String ownerMyVenue = '/api/owner/venue';
  static const String venueTonight = '/api/venues/{id}/tonight';
  static const String venueLive = '/api/venues/{id}/live';

  // -- Feed --
  static const String feed = '/feed';

  // -- Zone 4 feed (real backend; ticket 07) --
  static const String feedRanked = '/api/feed';

  // -- Going ("J'y vais", real backend; ticket 08) --
  static const String goingMark = '/api/going';
  static const String goingByVenue = '/api/going/venue/{venueId}';
  static const String goingMine = '/api/going/venue/{venueId}/mine';
  static const String goingOwnerSummary =
      '/api/going/venue/{venueId}/owner-summary';

  // -- Promo create (real backend; ticket 09) --
  static const String venuePromoCreate = '/api/feed/venue/{venueId}/promo';

  static const String promos = '/promos';
  static const String events = '/events';
  static const String eventInterest = '/events/{id}/interest';

  // -- Favorites --
  static const String favorites = '/favorites';
  static const String favoriteToggle = '/favorites/{venueId}';

  // -- Reviews --
  static const String reviews = '/reviews';

  // -- Notifications --
  static const String notifications = '/notifications';
  static const String notificationRead = '/notifications/{id}/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // -- Owner --
  static const String ownerDashboard = '/owner/dashboard';
  static const String ownerVenues = '/owner/venues';
  static const String ownerVenueDetail = '/owner/venues/{id}';
  static const String ownerPromos = '/owner/promos';
  static const String ownerPromoDetail = '/owner/promos/{id}';
  static const String ownerAnalytics = '/owner/analytics';
}
