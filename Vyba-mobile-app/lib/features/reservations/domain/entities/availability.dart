import 'package:flutter/foundation.dart';

/// Tonight's confirmed-reservation load for a reservations-enabled venue.
@immutable
class Availability {
  const Availability({
    required this.reservationsEnabled,
    required this.confirmedReservationsCount,
  });

  final bool reservationsEnabled;

  /// Sum of confirmed party sizes tonight; null when reservations aren't
  /// enabled for this venue.
  final int? confirmedReservationsCount;
}
