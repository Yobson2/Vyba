// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteDataSourceHash() =>
    r'df9698b6aefb315582872c8ab354d3cd1fdd60b9';

/// Provides the [AuthRemoteDataSource].
///
/// Set `USE_MOCK_AUTH=true` in `.env` to use mock data for testing.
/// Defaults to `false` — a real build must never ship with mock auth on.
///
/// Copied from [authRemoteDataSource].
@ProviderFor(authRemoteDataSource)
final authRemoteDataSourceProvider =
    AutoDisposeProvider<AuthRemoteDataSource>.internal(
  authRemoteDataSource,
  name: r'authRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteDataSourceRef = AutoDisposeProviderRef<AuthRemoteDataSource>;
String _$authLocalDataSourceHash() =>
    r'5900618b40b49ca0a6e497f88db80964e2964f82';

/// Provides the [AuthLocalDataSource].
///
/// Copied from [authLocalDataSource].
@ProviderFor(authLocalDataSource)
final authLocalDataSourceProvider =
    AutoDisposeProvider<AuthLocalDataSource>.internal(
  authLocalDataSource,
  name: r'authLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthLocalDataSourceRef = AutoDisposeProviderRef<AuthLocalDataSource>;
String _$authRepositoryHash() => r'035b079c06c4c0f98f1e45d75766cbd46a4ea376';

/// Provides the [AuthRepository].
///
/// Copied from [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = AutoDisposeProvider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = AutoDisposeProviderRef<AuthRepository>;
String _$requestOtpUseCaseHash() => r'65e0782e10c2c7621090fe810d84fa2728dc3199';

/// Provides the [RequestOtpUseCase].
///
/// Copied from [requestOtpUseCase].
@ProviderFor(requestOtpUseCase)
final requestOtpUseCaseProvider =
    AutoDisposeProvider<RequestOtpUseCase>.internal(
  requestOtpUseCase,
  name: r'requestOtpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestOtpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RequestOtpUseCaseRef = AutoDisposeProviderRef<RequestOtpUseCase>;
String _$verifyOtpUseCaseHash() => r'031122716f3e2b5d80082d3460d7dab6ab4998f1';

/// Provides the [VerifyOtpUseCase].
///
/// Copied from [verifyOtpUseCase].
@ProviderFor(verifyOtpUseCase)
final verifyOtpUseCaseProvider = AutoDisposeProvider<VerifyOtpUseCase>.internal(
  verifyOtpUseCase,
  name: r'verifyOtpUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$verifyOtpUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef VerifyOtpUseCaseRef = AutoDisposeProviderRef<VerifyOtpUseCase>;
String _$logoutUseCaseHash() => r'2b963e9e0eff2155f687d45b1b5c652ddb695d62';

/// Provides the [LogoutUseCase].
///
/// Copied from [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = AutoDisposeProvider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutUseCaseRef = AutoDisposeProviderRef<LogoutUseCase>;
String _$getCachedUserUseCaseHash() =>
    r'e493bb9c4579b27620fbfa950ec18ce71766e311';

/// Provides the [GetCachedUserUseCase].
///
/// Copied from [getCachedUserUseCase].
@ProviderFor(getCachedUserUseCase)
final getCachedUserUseCaseProvider =
    AutoDisposeProvider<GetCachedUserUseCase>.internal(
  getCachedUserUseCase,
  name: r'getCachedUserUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getCachedUserUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetCachedUserUseCaseRef = AutoDisposeProviderRef<GetCachedUserUseCase>;
String _$restoreSessionUseCaseHash() =>
    r'344e3ede5bce5ab261ccc5888a24be03d82595ef';

/// Provides the [RestoreSessionUseCase].
///
/// Copied from [restoreSessionUseCase].
@ProviderFor(restoreSessionUseCase)
final restoreSessionUseCaseProvider =
    AutoDisposeProvider<RestoreSessionUseCase>.internal(
  restoreSessionUseCase,
  name: r'restoreSessionUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$restoreSessionUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RestoreSessionUseCaseRef
    = AutoDisposeProviderRef<RestoreSessionUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
