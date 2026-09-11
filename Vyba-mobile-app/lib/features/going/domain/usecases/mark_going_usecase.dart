import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';

class MarkGoingUseCase extends UseCase<Going, GoingActionParams> {
  const MarkGoingUseCase(this._repository);

  final GoingRepository _repository;

  @override
  Future<Either<Failure, Going>> call(GoingActionParams params) {
    return _repository.mark(
      venueId: params.venueId,
      partySize: params.partySize,
      identityPublic: params.identityPublic,
    );
  }
}

@immutable
class GoingActionParams {
  const GoingActionParams({
    required this.venueId,
    this.partySize,
    this.identityPublic,
  });

  final String venueId;
  final int? partySize;
  final bool? identityPublic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoingActionParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          partySize == other.partySize &&
          identityPublic == other.identityPublic;

  @override
  int get hashCode => Object.hash(venueId, partySize, identityPublic);
}
