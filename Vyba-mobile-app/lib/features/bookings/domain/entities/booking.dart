import 'package:flutter/foundation.dart';

@immutable
class Booking {
  const Booking({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.venueImage,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.zone,
    required this.status,
    this.bookingReference,
    this.qrCode,
    this.createdAt,
  });

  final String id;
  final String venueId;
  final String venueName;
  final String venueImage;
  final DateTime date;
  final String timeSlot;
  final int guestCount;
  final BookingZone zone;
  final BookingStatus status;
  final String? bookingReference;
  final String? qrCode;
  final DateTime? createdAt;
}

enum BookingZone { indoorLounge, outdoorTerrace, vipBooth }

enum BookingStatus { pending, confirmed, cancelled, completed }
