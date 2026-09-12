import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/entities/opted_in_venue.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/repositories/broadcast_opt_in_repository.dart';

class GetMyOptInsUseCase extends UseCase<List<OptedInVenue>, NoParams> {
  const GetMyOptInsUseCase(this._repository);

  final BroadcastOptInRepository _repository;

  @override
  Future<Either<Failure, List<OptedInVenue>>> call(NoParams params) {
    return _repository.getMyOptIns();
  }
}
