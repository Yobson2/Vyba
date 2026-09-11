import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/repositories/venue_night_repository.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';

class SetLiveUseCase extends UseCase<VenueTonight, SetLiveParams> {
  const SetLiveUseCase(this._repository);

  final VenueNightRepository _repository;

  @override
  Future<Either<Failure, VenueTonight>> call(SetLiveParams params) {
    return _repository.setLive(
      venueId: params.venueId,
      isLive: params.isLive,
    );
  }
}

@immutable
class SetLiveParams {
  const SetLiveParams({required this.venueId, required this.isLive});

  final String venueId;
  final bool isLive;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetLiveParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          isLive == other.isLive;

  @override
  int get hashCode => Object.hash(venueId, isLive);
}
