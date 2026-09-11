import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/repositories/venue_night_repository.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';

class SetHeadlineUseCase extends UseCase<VenueTonight, SetHeadlineParams> {
  const SetHeadlineUseCase(this._repository);

  final VenueNightRepository _repository;

  @override
  Future<Either<Failure, VenueTonight>> call(SetHeadlineParams params) {
    return _repository.setHeadline(
      venueId: params.venueId,
      headline: params.headline,
      djName: params.djName,
    );
  }
}

@immutable
class SetHeadlineParams {
  const SetHeadlineParams({required this.venueId, this.headline, this.djName});

  final String venueId;
  final String? headline;
  final String? djName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetHeadlineParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          headline == other.headline &&
          djName == other.djName;

  @override
  int get hashCode => Object.hash(venueId, headline, djName);
}
