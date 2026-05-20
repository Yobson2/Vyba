import 'package:flutter/foundation.dart';

@immutable
class OwnerBooking {
  const OwnerBooking({
    required this.id,
    required this.guestName,
    required this.guestAvatarUrl,
    required this.date,
    required this.timeSlot,
    required this.guestCount,
    required this.areaLabel,
    required this.depositAmount,
    required this.status,
    this.bookingReference,
  });

  final String id;
  final String guestName;
  final String guestAvatarUrl;
  final DateTime date;
  final String timeSlot;
  final int guestCount;
  final String areaLabel;
  final double depositAmount;
  final OwnerBookingStatus status;
  final String? bookingReference;
}

enum OwnerBookingStatus { pending, confirmed, declined, completed }
