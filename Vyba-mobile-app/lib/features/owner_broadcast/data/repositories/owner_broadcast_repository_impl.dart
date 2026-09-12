import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/owner_broadcast/data/datasources/owner_broadcast_remote_datasource.dart';
import 'package:flutter_templates/features/owner_broadcast/domain/repositories/owner_broadcast_repository.dart';

class OwnerBroadcastRepositoryImpl implements OwnerBroadcastRepository {
  const OwnerBroadcastRepositoryImpl({
    required OwnerBroadcastRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final OwnerBroadcastRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, void>> sendBroadcast({
    required String venueId,
    required String message,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      await _remote.sendBroadcast(venueId: venueId, message: message);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
          code: e.code,
        ),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
