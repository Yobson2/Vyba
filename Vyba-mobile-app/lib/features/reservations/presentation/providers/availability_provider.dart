import 'package:flutter_templates/features/reservations/domain/entities/availability.dart';
import 'package:flutter_templates/features/reservations/presentation/providers/reservation_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'availability_provider.g.dart';

/// Tonight's confirmed-reservation load for [venueId] — only fetched by the
/// UI when the venue is `reservationsEnabled` (most venues never pay this
/// extra call).
@riverpod
Future<Availability> availability(AvailabilityRef ref, String venueId) async {
  final result = await ref.read(getAvailabilityUseCaseProvider).call(venueId);
  return result.fold(
    (failure) => const Availability(
      reservationsEnabled: true,
      confirmedReservationsCount: null,
    ),
    (availability) => availability,
  );
}
