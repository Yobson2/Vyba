import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/notification_preferences/data/datasources/notification_preferences_remote_datasource.dart';
import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';
import 'package:flutter_templates/features/notification_preferences/domain/repositories/notification_preferences_repository.dart';

class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  const NotificationPreferencesRepositoryImpl({
    required NotificationPreferencesRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final NotificationPreferencesRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, NotificationPreferences>> getPreferences() {
    return _guarded(_remote.getPreferences);
  }

  @override
  Future<Either<Failure, NotificationPreferences>> setPreferences({
    bool? weekendDigest,
    bool? goingReminder,
  }) {
    return _guarded(
      () => _remote.setPreferences(
        weekendDigest: weekendDigest,
        goingReminder: goingReminder,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> registerDeviceToken(String token) {
    return _guarded(() => _remote.registerDeviceToken(token));
  }

  @override
  Future<Either<Failure, void>> deregisterDeviceToken(String token) {
    return _guarded(() => _remote.deregisterDeviceToken(token));
  }

  Future<Either<Failure, T>> _guarded<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await call());
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
}
