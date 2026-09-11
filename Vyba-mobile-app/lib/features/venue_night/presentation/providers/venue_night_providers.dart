import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/venue_night/data/datasources/venue_night_remote_datasource.dart';
import 'package:flutter_templates/features/venue_night/data/repositories/venue_night_repository_impl.dart';
import 'package:flutter_templates/features/venue_night/domain/repositories/venue_night_repository.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/get_my_venue_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/get_tonight_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_headline_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_live_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_night_providers.g.dart';

@Riverpod(keepAlive: true)
VenueNightRemoteDataSource venueNightRemoteDataSource(
  VenueNightRemoteDataSourceRef ref,
) {
  return VenueNightRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
VenueNightRepository venueNightRepository(VenueNightRepositoryRef ref) {
  return VenueNightRepositoryImpl(
    remoteDataSource: ref.watch(venueNightRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
GetMyVenueUseCase getMyVenueUseCase(GetMyVenueUseCaseRef ref) {
  return GetMyVenueUseCase(ref.watch(venueNightRepositoryProvider));
}

@riverpod
GetTonightUseCase getTonightUseCase(GetTonightUseCaseRef ref) {
  return GetTonightUseCase(ref.watch(venueNightRepositoryProvider));
}

@riverpod
SetLiveUseCase setLiveUseCase(SetLiveUseCaseRef ref) {
  return SetLiveUseCase(ref.watch(venueNightRepositoryProvider));
}

@riverpod
SetHeadlineUseCase setHeadlineUseCase(SetHeadlineUseCaseRef ref) {
  return SetHeadlineUseCase(ref.watch(venueNightRepositoryProvider));
}
