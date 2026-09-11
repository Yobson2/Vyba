import 'package:flutter/foundation.dart';

/// A "J'y vais" mark for a venue tonight (ADR-0002 — soft intent, not a
/// reservation).
@immutable
class Going {
  const Going({
    required this.id,
    required this.venueId,
    required this.partySize,
    required this.identityPublic,
  });

  final String id;
  final String venueId;
  final int partySize;
  final bool identityPublic;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Going &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          venueId == other.venueId &&
          partySize == other.partySize &&
          identityPublic == other.identityPublic;

  @override
  int get hashCode => Object.hash(id, venueId, partySize, identityPublic);
}
