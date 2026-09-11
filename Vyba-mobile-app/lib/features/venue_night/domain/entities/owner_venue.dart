import 'package:flutter/foundation.dart';

/// The venue bound to the signed-in owner (validation MVP: one venue per
/// owner). Just enough to drive the night actions and display a name.
@immutable
class OwnerVenue {
  const OwnerVenue({required this.id, required this.name});

  final String id;
  final String name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerVenue &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'OwnerVenue(id: $id, name: $name)';
}
