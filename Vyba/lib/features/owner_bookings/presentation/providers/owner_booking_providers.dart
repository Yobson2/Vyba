import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/owner_bookings/data/datasources/mock_owner_booking_datasource.dart';
import 'package:flutter_templates/features/owner_bookings/data/repositories/owner_booking_repository_impl.dart';
import 'package:flutter_templates/features/owner_bookings/domain/entities/owner_booking.dart';
import 'package:flutter_templates/features/owner_bookings/domain/repositories/owner_booking_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_booking_providers.g.dart';

@Riverpod(keepAlive: true)
OwnerBookingDataSource ownerBookingDataSource(
  OwnerBookingDataSourceRef ref,
) {
  return MockOwnerBookingDataSource();
}

@Riverpod(keepAlive: true)
OwnerBookingRepository ownerBookingRepository(
  OwnerBookingRepositoryRef ref,
) {
  return OwnerBookingRepositoryImpl(
    ref.read(ownerBookingDataSourceProvider),
  );
}

@riverpod
Future<List<OwnerBooking>> ownerBookings(
  OwnerBookingsRef ref, {
  String? filter,
}) async {
  final repo = ref.read(ownerBookingRepositoryProvider);
  final result = await repo.getOwnerBookings(filter: filter);
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<OwnerBooking> bookings) => bookings,
  );
}

@riverpod
class OwnerBookingActions extends _$OwnerBookingActions {
  @override
  FutureOr<void> build() {}

  Future<void> confirm(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(ownerBookingRepositoryProvider);
    final result = await repo.confirmBooking(id);
    state = result.fold(
      (Failure failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (_) {
        ref.invalidate(ownerBookingsProvider);
        return const AsyncData(null);
      },
    );
  }

  Future<void> decline(String id) async {
    state = const AsyncLoading();
    final repo = ref.read(ownerBookingRepositoryProvider);
    final result = await repo.declineBooking(id);
    state = result.fold(
      (Failure failure) => AsyncError(Exception(failure.message), StackTrace.current),
      (_) {
        ref.invalidate(ownerBookingsProvider);
        return const AsyncData(null);
      },
    );
  }
}
