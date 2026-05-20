import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/venue_management/data/datasources/mock_venue_management_datasource.dart';
import 'package:flutter_templates/features/venue_management/data/repositories/venue_management_repository_impl.dart';
import 'package:flutter_templates/features/venue_management/domain/entities/venue_profile.dart';
import 'package:flutter_templates/features/venue_management/domain/repositories/venue_management_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'venue_management_providers.g.dart';

@Riverpod(keepAlive: true)
VenueManagementDataSource venueManagementDataSource(
  VenueManagementDataSourceRef ref,
) {
  return MockVenueManagementDataSource();
}

@Riverpod(keepAlive: true)
VenueManagementRepository venueManagementRepository(
  VenueManagementRepositoryRef ref,
) {
  return VenueManagementRepositoryImpl(
    ref.read(venueManagementDataSourceProvider),
  );
}

@riverpod
Future<List<VenueProfile>> myVenues(MyVenuesRef ref) async {
  final repo = ref.read(venueManagementRepositoryProvider);
  final result = await repo.getMyVenues();
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<VenueProfile> venues) => venues,
  );
}

@riverpod
class UpdateVenueNotifier extends _$UpdateVenueNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> saveVenue(VenueProfile venue) async {
    state = const AsyncLoading<void>();
    final repo = ref.read(venueManagementRepositoryProvider);
    final result = await repo.updateVenueProfile(venue);
    return result.fold(
      (Failure failure) {
        state = AsyncError<void>(
          Exception(failure.message),
          StackTrace.current,
        );
        return false;
      },
      (_) {
        ref.invalidate(myVenuesProvider);
        state = const AsyncData<void>(null);
        return true;
      },
    );
  }
}
