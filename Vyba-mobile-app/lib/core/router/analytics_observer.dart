import 'package:flutter/material.dart';
import 'package:flutter_templates/core/services/analytics_service.dart';

/// Navigator observer that logs screen views to [AnalyticsService].
///
/// Add this to GoRouter's `observers` list for automatic screen tracking.
class AnalyticsObserver extends NavigatorObserver {
  /// Creates an [AnalyticsObserver].
  AnalyticsObserver(this._analytics);

  final AnalyticsService _analytics;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _logScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) _logScreenView(previousRoute);
  }

  void _logScreenView(Route<dynamic> route) {
    final screenName = route.settings.name;
    if (screenName != null) {
      _analytics.logScreenView(screenName);
    }
  }
}
