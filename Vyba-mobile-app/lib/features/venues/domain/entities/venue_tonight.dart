import 'package:flutter/foundation.dart';

/// Tonight's state for a venue — live status, headline/DJ, going count.
///
/// Absent (`null` on [Venue.tonight]) means "rien d'annoncé ce soir": no
/// `VenueNight` row exists for today (ADR-0001 — night state never lives on
/// the venue itself).
@immutable
class VenueTonight {
  const VenueTonight({
    required this.isLive,
    required this.liveSince,
    required this.headline,
    required this.djName,
    required this.goingCount,
  });

  final bool isLive;
  final DateTime? liveSince;
  final String? headline;
  final String? djName;
  final int goingCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueTonight &&
          runtimeType == other.runtimeType &&
          isLive == other.isLive &&
          liveSince == other.liveSince &&
          headline == other.headline &&
          djName == other.djName &&
          goingCount == other.goingCount;

  @override
  int get hashCode =>
      Object.hash(isLive, liveSince, headline, djName, goingCount);

  @override
  String toString() =>
      'VenueTonight(isLive: $isLive, liveSince: $liveSince, headline: $headline, djName: $djName, goingCount: $goingCount)';
}
