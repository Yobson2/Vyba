// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsServiceHash() => r'a0023711ac2463aabfd253fa191a148257db9a94';

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
///
/// Copied from [analyticsService].
@ProviderFor(analyticsService)
final analyticsServiceProvider = Provider<AnalyticsService>.internal(
  analyticsService,
  name: r'analyticsServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$analyticsServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsServiceRef = ProviderRef<AnalyticsService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
