import 'package:flutter_templates/core/utils/logger.dart';

/// Abstract crash reporting interface.
///
/// Implement this with your preferred crash reporting service
/// (e.g., Firebase Crashlytics, Sentry, Datadog).
///
/// Example with Firebase Crashlytics:
/// ```dart
/// class FirebaseCrashReporter implements CrashReporter {
///   @override
///   Future<void> init() async {
///     await Firebase.initializeApp();
///     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
///   }
///
///   @override
///   void recordError(dynamic error, StackTrace? stackTrace, {bool fatal = false}) {
///     FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: fatal);
///   }
///   // ...
/// }
/// ```
abstract class CrashReporter {
  /// Initialize the crash reporting service.
  Future<void> init();

  /// Record a non-fatal or fatal error.
  void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
  });

  /// Associate a user with subsequent crash reports.
  void setUser(String userId);

  /// Clear the current user association (e.g., on logout).
  void clearUser();

  /// Add a breadcrumb log message for crash context.
  void log(String message);
}

/// Development crash reporter that logs errors locally.
///
/// Use this during development. Replace with a real implementation
/// (e.g., `FirebaseCrashReporter`) for staging/production builds.
class DevCrashReporter implements CrashReporter {
  @override
  Future<void> init() async {
    AppLogger.info('CrashReporter initialized (dev mode)', tag: 'Crash');
  }

  @override
  void recordError(
    dynamic error,
    StackTrace? stackTrace, {
    bool fatal = false,
  }) {
    AppLogger.error(
      'Crash${fatal ? ' [FATAL]' : ''}: $error',
      tag: 'Crash',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void setUser(String userId) {
    AppLogger.debug('CrashReporter user set: $userId', tag: 'Crash');
  }

  @override
  void clearUser() {
    AppLogger.debug('CrashReporter user cleared', tag: 'Crash');
  }

  @override
  void log(String message) {
    AppLogger.debug('CrashReporter breadcrumb: $message', tag: 'Crash');
  }
}
