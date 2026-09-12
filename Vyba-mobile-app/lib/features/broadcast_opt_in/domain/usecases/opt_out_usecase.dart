import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/repositories/broadcast_opt_in_repository.dart';

class OptOutUseCase extends UseCase<void, String> {
  const OptOutUseCase(this._repository);

  final BroadcastOptInRepository _repository;

  @override
  Future<Either<Failure, void>> call(String venueId) {
    return _repository.optOut(venueId);
  }
}
