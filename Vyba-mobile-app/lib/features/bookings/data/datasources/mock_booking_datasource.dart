import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/features/bookings/domain/entities/booking.dart';

/// Abstract interface for booking data source.
abstract class BookingDataSource {
  Future<List<String>> getAvailableSlots(String venueId, DateTime date);
  Future<Booking> createBooking({
    required String venueId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    required BookingZone zone,
  });
  Future<List<Booking>> getMyBookings({BookingStatus? filter});
  Future<void> cancelBooking(String bookingId);
}

/// Mock implementation with sample Abidjan venue bookings.
class MockBookingDataSource implements BookingDataSource {
  final List<Booking> _bookings = [
    Booking(
      id: 'bk-001',
      venueId: '1',
      venueName: 'The Vibe Lounge',
      venueImage:
          'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800',
      date: DateTime.now().add(const Duration(days: 2)),
      timeSlot: '21:00',
      guestCount: 4,
      zone: BookingZone.vipBooth,
      status: BookingStatus.confirmed,
      bookingReference: 'LP-VIB-4829',
      qrCode: 'qr_bk001',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Booking(
      id: 'bk-002',
      venueId: '3',
      venueName: 'Zaza Abidjan',
      venueImage:
          'https://images.unsplash.com/photo-1571204829887-3b8d69e4094d?w=800',
      date: DateTime.now().add(const Duration(days: 5)),
      timeSlot: '22:30',
      guestCount: 6,
      zone: BookingZone.outdoorTerrace,
      status: BookingStatus.pending,
      bookingReference: 'LP-ZAZ-7713',
      createdAt: DateTime.now(),
    ),
    Booking(
      id: 'bk-003',
      venueId: '5',
      venueName: 'Velvet Rooftop',
      venueImage:
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
      date: DateTime.now().subtract(const Duration(days: 10)),
      timeSlot: '20:00',
      guestCount: 2,
      zone: BookingZone.indoorLounge,
      status: BookingStatus.completed,
      bookingReference: 'LP-VEL-3391',
      qrCode: 'qr_bk003',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  int _idCounter = 4;

  @override
  Future<List<String>> getAvailableSlots(
    String venueId,
    DateTime date,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return [
      '19:00',
      '19:30',
      '20:00',
      '20:30',
      '21:00',
      '21:30',
      '22:00',
      '22:30',
      '23:00',
      '23:30',
    ];
  }

  @override
  Future<Booking> createBooking({
    required String venueId,
    required DateTime date,
    required String timeSlot,
    required int guestCount,
    required BookingZone zone,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final venueNames = {
      '1': 'The Vibe Lounge',
      '2': 'Jazzhole Cocody',
      '3': 'Zaza Abidjan',
      '4': 'Moist Beach Club',
      '5': 'Velvet Rooftop',
      '6': 'Shiro Restaurant',
    };
    final venueImages = {
      '1':
          'https://images.unsplash.com/photo-1566737236500-c8ac43014a67?w=800',
      '2':
          'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      '3':
          'https://images.unsplash.com/photo-1571204829887-3b8d69e4094d?w=800',
      '4':
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800',
      '5':
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=800',
      '6':
          'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
    };

    final ref = 'LP-${venueNames[venueId]?.substring(0, 3).toUpperCase() ?? 'UNK'}-${1000 + _idCounter}';
    final booking = Booking(
      id: 'bk-${_idCounter.toString().padLeft(3, '0')}',
      venueId: venueId,
      venueName: venueNames[venueId] ?? 'Unknown Venue',
      venueImage: venueImages[venueId] ?? '',
      date: date,
      timeSlot: timeSlot,
      guestCount: guestCount,
      zone: zone,
      status: BookingStatus.confirmed,
      bookingReference: ref,
      qrCode: 'qr_bk${_idCounter.toString().padLeft(3, '0')}',
      createdAt: DateTime.now(),
    );

    _idCounter++;
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<List<Booking>> getMyBookings({BookingStatus? filter}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (filter == null) return List.unmodifiable(_bookings);
    return _bookings.where((b) => b.status == filter).toList();
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index == -1) {
      throw const ServerException(message: 'Booking not found');
    }
    final old = _bookings[index];
    _bookings[index] = Booking(
      id: old.id,
      venueId: old.venueId,
      venueName: old.venueName,
      venueImage: old.venueImage,
      date: old.date,
      timeSlot: old.timeSlot,
      guestCount: old.guestCount,
      zone: old.zone,
      status: BookingStatus.cancelled,
      bookingReference: old.bookingReference,
      qrCode: old.qrCode,
      createdAt: old.createdAt,
    );
  }
}
