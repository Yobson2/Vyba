import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/services/analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

/// Provides the [AnalyticsService] instance.
///
/// Override this provider to swap in a real analytics service:
/// ```dart
/// ProviderScope(
///   overrides: [
///     analyticsServiceProvider.overrideWithValue(FirebaseAnalyticsService()),
///   ],
///   child: const App(),
/// )
/// ```
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  return DevAnalyticsService();
}
