import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_remote_datasource.dart';
// TODO(dev): Remove mock import when the app no longer needs offline demos.
import 'package:flutter_templates/features/auth/data/datasources/mock_auth_remote_datasource.dart';
import 'package:flutter_templates/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_templates/features/auth/domain/usecases/get_cached_user_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/request_otp_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:flutter_templates/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// Provides the [AuthRemoteDataSource].
///
/// Set `USE_MOCK_AUTH=true` in `.env` to use mock data for testing.
/// Defaults to `false` — a real build must never ship with mock auth on.
@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  final useMock = dotenv.get('USE_MOCK_AUTH', fallback: 'false') == 'true';
  if (useMock) {
    return MockAuthRemoteDataSource(
      localStorage: ref.watch(localStorageProvider),
    );
  }
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
}

/// Provides the [AuthLocalDataSource].
@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
    localStorage: ref.watch(localStorageProvider),
  );
}

/// Provides the [AuthRepository].
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

/// Provides the [RequestOtpUseCase].
@riverpod
RequestOtpUseCase requestOtpUseCase(Ref ref) {
  return RequestOtpUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [VerifyOtpUseCase].
@riverpod
VerifyOtpUseCase verifyOtpUseCase(Ref ref) {
  return VerifyOtpUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [LogoutUseCase].
@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [GetCachedUserUseCase].
@riverpod
GetCachedUserUseCase getCachedUserUseCase(Ref ref) {
  return GetCachedUserUseCase(ref.watch(authRepositoryProvider));
}

/// Provides the [RestoreSessionUseCase].
@riverpod
RestoreSessionUseCase restoreSessionUseCase(Ref ref) {
  return RestoreSessionUseCase(ref.watch(authRepositoryProvider));
}
