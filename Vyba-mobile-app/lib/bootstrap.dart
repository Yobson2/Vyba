import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/app.dart';
import 'package:flutter_templates/core/config/env.dart';
import 'package:flutter_templates/core/config/env_provider.dart';
import 'package:flutter_templates/core/providers/crash_reporter_provider.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/services/crash_reporter.dart';
import 'package:flutter_templates/core/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Bootstraps the application with the given [env] configuration.
///
/// Initializes bindings, storage, crash reporting, and wraps the app
/// in [ProviderScope] with environment-specific overrides.
Future<void> bootstrap(Env env, {CrashReporter? crashReporter}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file.
  await loadEnv();

  // Lock orientation to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SharedPreferences before the app starts.
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize crash reporting.
  final reporter = crashReporter ?? DevCrashReporter();
  await reporter.init();

  // Set up error handling — forward to crash reporter.
  FlutterError.onError = (details) {
    AppLogger.error(
      'Flutter error: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
    reporter.recordError(
      details.exception,
      details.stack,
      fatal: details.library == null,
    );
  };

  // Catch errors outside of Flutter framework.
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error('Platform error', error: error, stackTrace: stack);
    reporter.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    ProviderScope(
      overrides: [
        envProvider.overrideWithValue(env),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        crashReporterProvider.overrideWithValue(reporter),
      ],
      child: const App(),
    ),
  );
}

Future<void> loadEnv() async {
  try {
    if (!dotenv.isInitialized) {
      await dotenv.load();
      AppLogger.info('Environment variables loaded', tag: 'AppEngine');
    }
  } catch (e) {
    AppLogger.error('Failed to load environment', tag: 'AppEngine', error: e);
    rethrow;
  }
}
