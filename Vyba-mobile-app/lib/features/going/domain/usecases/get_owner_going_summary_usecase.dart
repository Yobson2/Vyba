import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/going/domain/entities/owner_going_summary.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';

class GetOwnerGoingSummaryUseCase extends UseCase<OwnerGoingSummary, String> {
  const GetOwnerGoingSummaryUseCase(this._repository);

  final GoingRepository _repository;

  @override
  Future<Either<Failure, OwnerGoingSummary>> call(String venueId) {
    return _repository.getOwnerSummary(venueId);
  }
}
