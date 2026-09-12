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

  // -- Attribution + analytics (real backend; ticket 11) --
  static const String attributionLanding = '/api/attribution/landing';
  static const String analyticsTrack = '/api/analytics/track';

  static const String promos = '/promos';
  static const String events = '/events';
  static const String eventInterest = '/events/{id}/interest';

  // -- Media / photo curation (real backend; ticket 14) --
  static const String mediaVenueNightPhoto = '/api/media/venue-night-photo';
  static const String mediaVenueNightPhotos =
      '/api/media/venue/{venueId}/night-photos';

  // -- Notifications (real backend; ticket 15) --
  static const String notificationsDeviceToken =
      '/api/notifications/device-token';
  static const String notificationsPreferences =
      '/api/notifications/preferences';

  // -- Venue broadcast opt-in + owner broadcast (real backend; ticket 17) --
  static const String broadcastOptIn =
      '/api/notifications/venue/{venueId}/opt-in';
  static const String broadcastOptIns = '/api/notifications/venue-opt-ins/mine';
  static const String venueBroadcast =
      '/api/notifications/venue/{venueId}/broadcast';

  // -- Follows ("mes lieux suivis", real backend; ticket 10) --
  static const String followByVenue = '/api/follows/venue/{venueId}';
  static const String followMine = '/api/follows/venue/{venueId}/mine';
  static const String followedVenues = '/api/follows/mine';

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
