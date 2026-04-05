import 'package:flutter_templates/features/venues/data/datasources/mock_venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/repositories/venue_repository_impl.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';
import 'package:flutter_templates/features/venues/domain/usecases/get_venue_detail_usecase.dart';
import 'package:flutter_templates/features/venues/domain/usecases/get_venue_menu_usecase.dart';
import 'package:flutter_templates/features/venues/domain/usecases/get_venues_usecase.dart';
import 'package:flutter_templates/features/venues/domain/usecases/search_venues_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_providers.g.dart';

@Riverpod(keepAlive: true)
VenueRemoteDataSource venueRemoteDataSource(VenueRemoteDataSourceRef ref) {
  return MockVenueRemoteDataSource();
}

@Riverpod(keepAlive: true)
VenueRepository venueRepository(VenueRepositoryRef ref) {
  return VenueRepositoryImpl(ref.read(venueRemoteDataSourceProvider));
}

@riverpod
GetVenuesUseCase getVenuesUseCase(GetVenuesUseCaseRef ref) {
  return GetVenuesUseCase(ref.read(venueRepositoryProvider));
}

@riverpod
GetVenueDetailUseCase getVenueDetailUseCase(GetVenueDetailUseCaseRef ref) {
  return GetVenueDetailUseCase(ref.read(venueRepositoryProvider));
}

@riverpod
GetVenueMenuUseCase getVenueMenuUseCase(GetVenueMenuUseCaseRef ref) {
  return GetVenueMenuUseCase(ref.read(venueRepositoryProvider));
}

@riverpod
SearchVenuesUseCase searchVenuesUseCase(SearchVenuesUseCaseRef ref) {
  return SearchVenuesUseCase(ref.read(venueRepositoryProvider));
}
