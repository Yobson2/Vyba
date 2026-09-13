import 'package:flutter/foundation.dart';

/// A real table/seat request (ADR-0006) — opt-in per venue, unlike the
/// unconditional "J'y vais" (ADR-0002). The owner confirms or rejects it.
enum ReservationStatus { pending, confirmed, rejected, canceled }

@immutable
class Reservation {
  const Reservation({
    required this.id,
    required this.venueId,
    required this.partySize,
    required this.note,
    required this.status,
  });

  final String id;
  final String venueId;
  final int partySize;
  final String? note;
  final ReservationStatus status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          venueId == other.venueId &&
          partySize == other.partySize &&
          note == other.note &&
          status == other.status;

  @override
  int get hashCode => Object.hash(id, venueId, partySize, note, status);
}
