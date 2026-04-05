import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
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
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.login(email: email, password: password);
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await _remote.register(
        name: name,
        email: email,
        password: password,
      );
      await _local.cacheTokens(result.tokens);
      await _local.cacheUser(result.user);
      return Right(result.user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.forgotPassword(email: email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp({
    required String email,
    required String code,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.verifyOtp(email: email, code: code);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      if (await _networkInfo.isConnected) {
        await _remote.logout();
      }
      await _local.clearAll();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (_) {
      await _local.clearAll();
      return const Right(null);
    }
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
  Future<bool> get isAuthenticated => _local.hasToken();
}
