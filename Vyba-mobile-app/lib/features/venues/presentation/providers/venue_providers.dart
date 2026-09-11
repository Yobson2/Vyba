import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/venues/data/datasources/mock_venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource.dart';
import 'package:flutter_templates/features/venues/data/datasources/venue_remote_datasource_impl.dart';
import 'package:flutter_templates/features/venues/data/repositories/venue_repository_impl.dart';
import 'package:flutter_templates/features/venues/domain/repositories/venue_repository.dart';
import 'package:flutter_templates/features/venues/domain/usecases/get_venue_detail_usecase.dart';
import 'package:flutter_templates/features/venues/domain/usecases/get_venues_usecase.dart';
import 'package:flutter_templates/features/venues/domain/usecases/search_venues_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_providers.g.dart';

/// Backs the Explore listing. Still mock — the backend has no public venue
/// *list* endpoint yet (a later ticket).
// TODO(dev): Point this at the real backend once the public list endpoint exists.
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
SearchVenuesUseCase searchVenuesUseCase(SearchVenuesUseCaseRef ref) {
  return SearchVenuesUseCase(ref.read(venueRepositoryProvider));
}

/// Backs venue *detail* (ticket 06) — real backend, distinct from the
/// mock-backed listing provider above.
@Riverpod(keepAlive: true)
VenueRemoteDataSource venueDetailRemoteDataSource(
  VenueDetailRemoteDataSourceRef ref,
) {
  return VenueRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
VenueRepository venueDetailRepository(VenueDetailRepositoryRef ref) {
  return VenueRepositoryImpl(ref.read(venueDetailRemoteDataSourceProvider));
}

@riverpod
GetVenueDetailUseCase getVenueDetailUseCase(GetVenueDetailUseCaseRef ref) {
  return GetVenueDetailUseCase(ref.read(venueDetailRepositoryProvider));
}
