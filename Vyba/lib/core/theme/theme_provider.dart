import 'package:flutter/material.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Manages the app [ThemeMode] and persists the user's preference.
///
/// Supports system, light, and dark modes. Persists choice via
/// [LocalStorage] so it survives app restarts.
@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    final stored = ref.read(localStorageProvider).getThemeMode();
    return _fromString(stored);
  }

  /// Sets the theme mode and persists it.
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await ref.read(localStorageProvider).setThemeMode(_toString(mode));
  }

  /// Toggles between light and dark (skipping system).
  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  static ThemeMode _fromString(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String _toString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
