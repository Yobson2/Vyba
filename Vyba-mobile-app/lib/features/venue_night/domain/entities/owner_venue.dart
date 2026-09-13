import 'package:flutter/foundation.dart';

/// The venue bound to the signed-in owner (validation MVP: one venue per
/// owner). Just enough to drive the night actions and display a name.
@immutable
class OwnerVenue {
  const OwnerVenue({
    required this.id,
    required this.name,
    this.reservationsEnabled = false,
  });

  final String id;
  final String name;

  /// Opt-in real reservations (ADR-0006) — admin-set, drives whether the
  /// owner home shows the reservations request list.
  final bool reservationsEnabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerVenue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          reservationsEnabled == other.reservationsEnabled;

  @override
  int get hashCode => Object.hash(id, name, reservationsEnabled);

  @override
  String toString() =>
      'OwnerVenue(id: $id, name: $name, reservationsEnabled: $reservationsEnabled)';
}
