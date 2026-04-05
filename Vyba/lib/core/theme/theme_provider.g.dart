// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeModeNotifierHash() => r'1fb264ef8b097bea16a059049f0ad381f8185e01';

/// Manages the app [ThemeMode] and persists the user's preference.
///
/// Supports system, light, and dark modes. Persists choice via
/// [LocalStorage] so it survives app restarts.
///
/// Copied from [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
