// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'env_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$envHash() => r'53134ac8e9d49ab1bdd05340b1e7aaca7c8e4a73';

/// Provides the current [Env] configuration.
///
/// Override this provider in `ProviderScope.overrides` at bootstrap
/// to inject the correct environment per build flavor.
///
/// Copied from [env].
@ProviderFor(env)
final envProvider = Provider<Env>.internal(
  env,
  name: r'envProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$envHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnvRef = ProviderRef<Env>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
