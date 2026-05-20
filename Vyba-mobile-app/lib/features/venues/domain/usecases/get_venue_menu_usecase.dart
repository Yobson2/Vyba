import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_menu.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';

class GetVenueMenuUseCase extends UseCase<VenueMenu, String> {
  GetVenueMenuUseCase(this._repository);

  final VenueRepository _repository;

  @override
  Future<Either<Failure, VenueMenu>> call(String params) {
    return _repository.getVenueMenu(params);
  }
}
