import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_templates/core/network/api_endpoints.dart';
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

/// Forwards events to the backend's PostHog proxy (`POST /api/analytics/track`,
/// ticket 11 / spec 07). The proxy attaches the internal user id from the
/// JWT (already carried by [dio]'s auth interceptor) when signed in, or
/// falls back to [anonymousId] pre-signup — so this class never needs to
/// know whether the caller is authenticated.
///
/// Provenance-sensitive action events (`going_marked`, `venue_followed`,
/// `post_created*`, ...) are emitted server-side instead of from here, to
/// avoid double-counting — see the respective backend services. This class
/// only carries pure view/session events the backend has no visibility
/// into (`feed_opened`, `feed_item_viewed`, `venue_viewed`, ...).
class RealAnalyticsService implements AnalyticsService {
  RealAnalyticsService(this._dio, this._anonymousId);

  final Dio _dio;
  final String Function() _anonymousId;

  @override
  Future<void> init() async {
    AppLogger.info('AnalyticsService initialized (proxy mode)', tag: 'Analytics');
  }

  @override
  void logEvent(String name, [Map<String, Object>? params]) {
    unawaited(_send(name, params));
  }

  Future<void> _send(String name, Map<String, Object>? params) async {
    try {
      await _dio.post<void>(
        ApiEndpoints.analyticsTrack,
        data: {
          'event': name,
          'anonymousId': _anonymousId(),
          if (params != null) 'properties': params,
        },
      );
    } catch (e) {
      // Analytics must never crash or block the app.
      AppLogger.debug('Event forward failed: $name ($e)', tag: 'Analytics');
    }
  }

  @override
  void setUser(String userId) {}

  @override
  void clearUser() {}

  @override
  void logScreenView(String screenName) {
    // Not forwarded: `screen_view` isn't part of the taxonomy (spec 07) —
    // the proxy would reject it. Screen-level tracking isn't this ticket's
    // event list; local-only for now.
    AppLogger.debug('Screen: $screenName', tag: 'Analytics');
  }
}
