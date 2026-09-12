import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/services/analytics_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_provider.g.dart';

/// Provides the [AnalyticsService] instance — forwards to the backend's
/// PostHog proxy (ticket 11) using the persisted anonymous client id.
@Riverpod(keepAlive: true)
AnalyticsService analyticsService(Ref ref) {
  final localStorage = ref.watch(localStorageProvider);
  return RealAnalyticsService(
    ref.watch(dioProvider),
    localStorage.getOrCreateClientId,
  );
}
