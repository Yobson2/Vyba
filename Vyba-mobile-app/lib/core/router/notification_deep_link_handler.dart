import 'package:go_router/go_router.dart';

/// The single notification-tap → destination mapping (ticket 15 / spec 08):
/// a weekend digest opens the feed, a going reminder opens the venue. Takes
/// the FCM payload's `data` map directly, so it plugs into whichever stream
/// eventually delivers it (`FirebaseMessaging.onMessageOpenedApp`,
/// `getInitialMessage()` for a cold start) without change once a real push
/// provider is wired — see `PushNotificationService`.
void handleNotificationTap(GoRouter router, Map<String, dynamic> data) {
  final type = data['type'] as String?;
  switch (type) {
    case 'weekend_digest':
      router.go('/feed');
    case 'going_reminder':
      final venueId = data['venueId'] as String?;
      if (venueId != null && venueId.isNotEmpty) {
        router.go('/explore/venue/$venueId');
      } else {
        router.go('/feed');
      }
    default:
      // Unknown/absent type — land on the feed rather than doing nothing.
      router.go('/feed');
  }
}
