import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/core/utils/jwt_utils.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:flutter_templates/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] that coordinates between
/// remote and local data sources.
class AuthRepositoryImpl implements AuthRepository {
  /// Creates an [AuthRepositoryImpl].
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _local = localDataSource,
        _networkInfo = networkInfo;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, void>> requestOtp({
    required String phoneNumber,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.requestOtp(phoneNumber: phoneNumber);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
            message: e.message, statusCode: e.statusCode, code: e.code),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String phoneNumber,
    required String code,
    bool? ageConfirmed,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.verifyOtp(
        phoneNumber: phoneNumber,
        code: code,
        ageConfirmed: ageConfirmed,
      );
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      await _local.markSignedIn();
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
            message: e.message, statusCode: e.statusCode, code: e.code),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await _local.clearAll();
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> getCachedUser() async {
    try {
      final model = await _local.getCachedUser();
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, User>> restoreSession() async {
    try {
      final cached = await _local.getCachedUser();
      final accessToken = await _local.getAccessToken();
      if (accessToken == null || !isJwtExpired(accessToken)) {
        return Right(cached.toEntity());
      }

      final refreshToken = await _local.getRefreshToken();
      if (refreshToken == null) {
        await _local.clearAll();
        return const Left(UnauthorizedFailure(message: 'Session expirée'));
      }

      if (!await _networkInfo.isConnected) {
        // Offline with an expired token we can't refresh yet — don't lock
        // the user out; the interceptor will refresh on the next request.
        return Right(cached.toEntity());
      }

      final result = await _remote.refresh(refreshToken: refreshToken);
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      await _local.clearAll();
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      await _local.clearAll();
      return Left(
        ServerFailure(
            message: e.message, statusCode: e.statusCode, code: e.code),
      );
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<bool> get isAuthenticated => _local.hasToken();
}
