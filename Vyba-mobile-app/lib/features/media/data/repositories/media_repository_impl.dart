import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/media/data/datasources/media_remote_datasource.dart';
import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';
import 'package:flutter_templates/features/media/domain/repositories/media_repository.dart';

class MediaRepositoryImpl implements MediaRepository {
  const MediaRepositoryImpl({
    required MediaRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final MediaRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, VenueNightPhoto>> uploadVenueNightPhoto({
    required String venueId,
    required String filePath,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(
        await _remote.uploadVenueNightPhoto(
          venueId: venueId,
          filePath: filePath,
        ),
      );
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, List<VenueNightPhoto>>> getVenueNightPhotos(
    String venueId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      return Right(await _remote.getVenueNightPhotos(venueId));
    } on ServerException catch (e) {
      return Left(_serverFailure(e));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }

  ServerFailure _serverFailure(ServerException e) => ServerFailure(
        message: e.message,
        statusCode: e.statusCode,
        code: e.code,
      );
}
