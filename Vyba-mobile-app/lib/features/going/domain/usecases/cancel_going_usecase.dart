import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';

class CancelGoingUseCase extends UseCase<void, String> {
  const CancelGoingUseCase(this._repository);

  final GoingRepository _repository;

  @override
  Future<Either<Failure, void>> call(String venueId) {
    return _repository.cancel(venueId);
  }
}
