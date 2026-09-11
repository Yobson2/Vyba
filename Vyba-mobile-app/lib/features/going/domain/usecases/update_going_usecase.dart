import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';
import 'package:flutter_templates/features/going/domain/usecases/mark_going_usecase.dart';

class UpdateGoingUseCase extends UseCase<Going, GoingActionParams> {
  const UpdateGoingUseCase(this._repository);

  final GoingRepository _repository;

  @override
  Future<Either<Failure, Going>> call(GoingActionParams params) {
    return _repository.update(
      venueId: params.venueId,
      partySize: params.partySize,
      identityPublic: params.identityPublic,
    );
  }
}
