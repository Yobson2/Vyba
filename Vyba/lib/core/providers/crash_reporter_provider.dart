import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/services/crash_reporter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'crash_reporter_provider.g.dart';

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
@Riverpod(keepAlive: true)
CrashReporter crashReporter(Ref ref) {
  return DevCrashReporter();
}
