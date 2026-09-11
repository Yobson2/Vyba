import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/network/network_info.dart';
import 'package:flutter_templates/features/promotions/data/datasources/promo_remote_datasource.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';
import 'package:flutter_templates/features/promotions/domain/repositories/promo_repository.dart';

class PromoRepositoryImpl implements PromoRepository {
  const PromoRepositoryImpl({
    required PromoRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remote = remoteDataSource,
        _networkInfo = networkInfo;

  final PromoRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, Promo>> createPromo({
    required String venueId,
    required String title,
    required String description,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final promo = await _remote.createPromo(
        venueId: venueId,
        title: title,
        description: description,
      );
      return Right(promo);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(message: e.message, statusCode: e.statusCode, code: e.code),
      );
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.code));
    } on NetworkException {
      return const Left(NetworkFailure());
    }
  }
}
