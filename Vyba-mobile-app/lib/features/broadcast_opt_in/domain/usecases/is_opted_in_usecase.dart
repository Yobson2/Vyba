import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/repositories/broadcast_opt_in_repository.dart';

class IsOptedInUseCase extends UseCase<bool, String> {
  const IsOptedInUseCase(this._repository);

  final BroadcastOptInRepository _repository;

  @override
  Future<Either<Failure, bool>> call(String venueId) {
    return _repository.isOptedIn(venueId);
  }
}
