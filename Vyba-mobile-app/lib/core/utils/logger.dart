import 'dart:developer' as developer;

/// Application logger that wraps `dart:developer` log.
///
/// Provides leveled logging with colored output for debug builds.
/// Use this instead of `print()` throughout the application.
class AppLogger {
  const AppLogger._();

  /// Log a debug message.
  static void debug(String message, {String? tag}) {
    _log(message, tag: tag ?? 'DEBUG', level: 500);
  }

  /// Log an info message.
  static void info(String message, {String? tag}) {
    _log(message, tag: tag ?? 'INFO', level: 800);
  }

  /// Log a warning message.
  static void warning(String message, {String? tag}) {
    _log(message, tag: tag ?? 'WARNING', level: 900);
  }

  /// Log an error message with optional [error] and [stackTrace].
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      message,
      tag: tag ?? 'ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(
    String message, {
    required String tag,
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
