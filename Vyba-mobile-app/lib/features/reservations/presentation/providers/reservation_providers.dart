import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/reservations/data/datasources/reservation_remote_datasource.dart';
import 'package:flutter_templates/features/reservations/data/repositories/reservation_repository_impl.dart';
import 'package:flutter_templates/features/reservations/domain/repositories/reservation_repository.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/cancel_reservation_usecase.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/create_reservation_usecase.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/get_availability_usecase.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/get_mine_reservation_usecase.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/list_owner_reservations_usecase.dart';
import 'package:flutter_templates/features/reservations/domain/usecases/respond_reservation_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reservation_providers.g.dart';

@Riverpod(keepAlive: true)
ReservationRemoteDataSource reservationRemoteDataSource(
  ReservationRemoteDataSourceRef ref,
) {
  return ReservationRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
ReservationRepository reservationRepository(ReservationRepositoryRef ref) {
  return ReservationRepositoryImpl(
    remoteDataSource: ref.watch(reservationRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
GetMineReservationUseCase getMineReservationUseCase(
  GetMineReservationUseCaseRef ref,
) {
  return GetMineReservationUseCase(ref.watch(reservationRepositoryProvider));
}

@riverpod
CreateReservationUseCase createReservationUseCase(
  CreateReservationUseCaseRef ref,
) {
  return CreateReservationUseCase(ref.watch(reservationRepositoryProvider));
}

@riverpod
CancelReservationUseCase cancelReservationUseCase(
  CancelReservationUseCaseRef ref,
) {
  return CancelReservationUseCase(ref.watch(reservationRepositoryProvider));
}

@riverpod
GetAvailabilityUseCase getAvailabilityUseCase(
  GetAvailabilityUseCaseRef ref,
) {
  return GetAvailabilityUseCase(ref.watch(reservationRepositoryProvider));
}

@riverpod
ListOwnerReservationsUseCase listOwnerReservationsUseCase(
  ListOwnerReservationsUseCaseRef ref,
) {
  return ListOwnerReservationsUseCase(ref.watch(reservationRepositoryProvider));
}

@riverpod
RespondReservationUseCase respondReservationUseCase(
  RespondReservationUseCaseRef ref,
) {
  return RespondReservationUseCase(ref.watch(reservationRepositoryProvider));
}
