import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/config/app_config.dart';
import 'package:flutter_templates/core/config/env_provider.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates a test app wrapped with [ProviderScope] and localization support.
///
/// Use [overrides] to inject mock providers for testing.
Widget createTestApp({
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

/// Sets up common test dependencies and returns provider overrides.
///
/// Call this in `setUp` or at the beginning of each test.
Future<List<Override>> createTestOverrides() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();

  return [
    envProvider.overrideWithValue(const AppConfig()),
    sharedPreferencesProvider.overrideWithValue(prefs),
  ];
}

/// Pumps the widget and settles all animations.
Future<void> pumpAndSettle(
  WidgetTester tester,
  Widget widget, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    createTestApp(child: widget, overrides: overrides),
  );
  await tester.pumpAndSettle();
}
