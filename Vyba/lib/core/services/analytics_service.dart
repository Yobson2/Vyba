import 'package:flutter_templates/core/utils/logger.dart';

/// Abstract analytics interface.
///
/// Implement this with your preferred analytics service
/// (e.g., Firebase Analytics, Mixpanel, Amplitude, PostHog).
///
/// Example with Firebase Analytics:
/// ```dart
/// class FirebaseAnalyticsService implements AnalyticsService {
///   final _analytics = FirebaseAnalytics.instance;
///
///   @override
///   Future<void> init() async => Firebase.initializeApp();
///
///   @override
///   void logEvent(String name, [Map<String, Object>? params]) {
///     _analytics.logEvent(name: name, parameters: params);
///   }
///   // ...
/// }
/// ```
abstract class AnalyticsService {
  /// Initialize the analytics service.
  Future<void> init();

  /// Log a custom event with optional parameters.
  void logEvent(String name, [Map<String, Object>? params]);

  /// Associate a user with subsequent events.
  void setUser(String userId);

  /// Clear the current user association (e.g., on logout).
  void clearUser();

  /// Log a screen view event.
  void logScreenView(String screenName);
}

/// Development analytics service that logs events locally.
///
/// Use this during development. Replace with a real implementation
/// for staging/production builds.
class DevAnalyticsService implements AnalyticsService {
  @override
  Future<void> init() async {
    AppLogger.info('AnalyticsService initialized (dev mode)', tag: 'Analytics');
  }

  @override
  void logEvent(String name, [Map<String, Object>? params]) {
    AppLogger.debug(
      'Event: $name${params != null ? ' $params' : ''}',
      tag: 'Analytics',
    );
  }

  @override
  void setUser(String userId) {
    AppLogger.debug('User set: $userId', tag: 'Analytics');
  }

  @override
  void clearUser() {
    AppLogger.debug('User cleared', tag: 'Analytics');
  }

  @override
  void logScreenView(String screenName) {
    AppLogger.debug('Screen: $screenName', tag: 'Analytics');
  }
}
