import 'package:flutter_templates/core/error/exceptions.dart';
import 'package:flutter_templates/features/owner_bookings/domain/entities/owner_booking.dart';

abstract class OwnerBookingDataSource {
  Future<List<OwnerBooking>> getOwnerBookings({String? filter});
  Future<OwnerBooking> confirmBooking(String id);
  Future<OwnerBooking> declineBooking(String id);
}

class MockOwnerBookingDataSource implements OwnerBookingDataSource {
  final List<OwnerBooking> _bookings = [
    OwnerBooking(
      id: 'obk-001',
      guestName: 'Amara Obi',
      guestAvatarUrl: 'https://i.pravatar.cc/150?img=1',
      date: DateTime.now(),
      timeSlot: '21:00',
      guestCount: 6,
      areaLabel: 'VIP Booth',
      depositAmount: 50000,
      status: OwnerBookingStatus.pending,
      bookingReference: 'LP-VIB-4829',
    ),
    OwnerBooking(
      id: 'obk-002',
      guestName: 'Chidi Eze',
      guestAvatarUrl: 'https://i.pravatar.cc/150?img=3',
      date: DateTime.now(),
      timeSlot: '22:30',
      guestCount: 4,
      areaLabel: 'Indoor Lounge',
      depositAmount: 25000,
      status: OwnerBookingStatus.pending,
      bookingReference: 'LP-VIB-4830',
    ),
    OwnerBooking(
      id: 'obk-003',
      guestName: 'Funke Adeyemi',
      guestAvatarUrl: 'https://i.pravatar.cc/150?img=5',
      date: DateTime.now(),
      timeSlot: '20:00',
      guestCount: 8,
      areaLabel: 'Outdoor Terrace',
      depositAmount: 75000,
      status: OwnerBookingStatus.confirmed,
      bookingReference: 'LP-VIB-4831',
    ),
    OwnerBooking(
      id: 'obk-004',
      guestName: 'Tunde Bakare',
      guestAvatarUrl: 'https://i.pravatar.cc/150?img=8',
      date: DateTime.now(),
      timeSlot: '23:00',
      guestCount: 2,
      areaLabel: 'VIP Booth',
      depositAmount: 50000,
      status: OwnerBookingStatus.confirmed,
      bookingReference: 'LP-VIB-4832',
    ),
  ];

  @override
  Future<List<OwnerBooking>> getOwnerBookings({String? filter}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (filter == null || filter.isEmpty) return List.unmodifiable(_bookings);
    return _bookings
        .where((b) => b.status.name.toLowerCase() == filter.toLowerCase())
        .toList();
  }

  @override
  Future<OwnerBooking> confirmBooking(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) {
      throw const ServerException(message: 'Booking not found');
    }
    final old = _bookings[index];
    final updated = OwnerBooking(
      id: old.id,
      guestName: old.guestName,
      guestAvatarUrl: old.guestAvatarUrl,
      date: old.date,
      timeSlot: old.timeSlot,
      guestCount: old.guestCount,
      areaLabel: old.areaLabel,
      depositAmount: old.depositAmount,
      status: OwnerBookingStatus.confirmed,
      bookingReference: old.bookingReference,
    );
    _bookings[index] = updated;
    return updated;
  }

  @override
  Future<OwnerBooking> declineBooking(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final index = _bookings.indexWhere((b) => b.id == id);
    if (index == -1) {
      throw const ServerException(message: 'Booking not found');
    }
    final old = _bookings[index];
    final updated = OwnerBooking(
      id: old.id,
      guestName: old.guestName,
      guestAvatarUrl: old.guestAvatarUrl,
      date: old.date,
      timeSlot: old.timeSlot,
      guestCount: old.guestCount,
      areaLabel: old.areaLabel,
      depositAmount: old.depositAmount,
      status: OwnerBookingStatus.declined,
      bookingReference: old.bookingReference,
    );
    _bookings[index] = updated;
    return updated;
  }
}
