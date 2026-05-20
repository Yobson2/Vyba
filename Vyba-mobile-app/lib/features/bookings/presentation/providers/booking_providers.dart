import 'package:flutter_templates/features/bookings/data/datasources/mock_booking_datasource.dart';
import 'package:flutter_templates/features/bookings/data/repositories/booking_repository_impl.dart';
import 'package:flutter_templates/features/bookings/domain/repositories/booking_repository.dart';
import 'package:flutter_templates/features/bookings/domain/usecases/create_booking_usecase.dart';
import 'package:flutter_templates/features/bookings/domain/usecases/get_my_bookings_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_providers.g.dart';

@Riverpod(keepAlive: true)
BookingDataSource bookingDataSource(BookingDataSourceRef ref) {
  return MockBookingDataSource();
}

@Riverpod(keepAlive: true)
BookingRepository bookingRepository(BookingRepositoryRef ref) {
  return BookingRepositoryImpl(ref.read(bookingDataSourceProvider));
}

@riverpod
CreateBookingUseCase createBookingUseCase(CreateBookingUseCaseRef ref) {
  return CreateBookingUseCase(ref.read(bookingRepositoryProvider));
}

@riverpod
GetMyBookingsUseCase getMyBookingsUseCase(GetMyBookingsUseCaseRef ref) {
  return GetMyBookingsUseCase(ref.read(bookingRepositoryProvider));
}
