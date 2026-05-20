import 'package:shared_preferences/shared_preferences.dart';

/// Wrapper around [SharedPreferences] for non-sensitive local data.
///
/// Used for settings, cache flags, and feature toggles.
class LocalStorage {
  /// Creates a [LocalStorage] with the given [prefs] instance.
  const LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _themeModeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _onboardingCompleteKey = 'onboarding_complete';
  static const _firstLaunchKey = 'first_launch';

  // -- Theme --

  /// Gets the persisted theme mode string (system/light/dark).
  String? getThemeMode() => _prefs.getString(_themeModeKey);

  /// Persists the theme mode [value].
  Future<bool> setThemeMode(String value) =>
      _prefs.setString(_themeModeKey, value);

  // -- Locale --

  /// Gets the persisted locale code (e.g. 'en', 'fr').
  String? getLocale() => _prefs.getString(_localeKey);

  /// Persists the locale [code].
  Future<bool> setLocale(String code) => _prefs.setString(_localeKey, code);

  // -- Onboarding --

  /// Whether the user has completed onboarding.
  bool get isOnboardingComplete =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  /// Marks onboarding as complete.
  Future<bool> setOnboardingComplete() =>
      _prefs.setBool(_onboardingCompleteKey, true);

  // -- First Launch --

  /// Whether this is the first app launch.
  bool get isFirstLaunch => _prefs.getBool(_firstLaunchKey) ?? true;

  /// Marks the first launch as done.
  Future<bool> setFirstLaunchDone() => _prefs.setBool(_firstLaunchKey, false);

  // -- Generic --

  /// Reads a string value by [key].
  String? getString(String key) => _prefs.getString(key);

  /// Writes a string [value] for the given [key].
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// Reads a bool value by [key].
  bool? getBool(String key) => _prefs.getBool(key);

  /// Writes a bool [value] for the given [key].
  Future<bool> setBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  /// Removes a value by [key].
  Future<bool> remove(String key) => _prefs.remove(key);

  /// Clears all stored data.
  Future<bool> clear() => _prefs.clear();
}
