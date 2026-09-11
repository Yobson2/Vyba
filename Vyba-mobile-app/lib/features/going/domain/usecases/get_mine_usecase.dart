import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';

class GetMineUseCase extends UseCase<Going?, String> {
  const GetMineUseCase(this._repository);

  final GoingRepository _repository;

  @override
  Future<Either<Failure, Going?>> call(String venueId) {
    return _repository.getMine(venueId);
  }
}
