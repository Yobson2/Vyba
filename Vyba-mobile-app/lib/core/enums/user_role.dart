/// User role determining which navigation shell and features are available.
enum UserRole {
  /// Client user — discovers venues, signals "J'y vais", views the feed.
  client,

  /// Venue owner — creates promotions, tracks basic activity.
  venueOwner,
}
