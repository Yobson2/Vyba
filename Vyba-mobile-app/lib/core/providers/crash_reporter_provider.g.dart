// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_reporter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$crashReporterHash() => r'60d64b0236bc07e2ce9e4f90031eb70b1cf26991';

/// Provides the [CrashReporter] instance.
///
/// Override this provider to swap in a real crash reporting service:
/// ```dart
/// ProviderScope(
///   overrides: [
///     crashReporterProvider.overrideWithValue(FirebaseCrashReporter()),
///   ],
///   child: const App(),
/// )
/// ```
///
/// Copied from [crashReporter].
@ProviderFor(crashReporter)
final crashReporterProvider = Provider<CrashReporter>.internal(
  crashReporter,
  name: r'crashReporterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$crashReporterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CrashReporterRef = ProviderRef<CrashReporter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
