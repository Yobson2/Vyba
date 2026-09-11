import 'package:flutter/foundation.dart';

/// Owner-facing "J'y vais" texture: count + rough party sizes, no identity.
@immutable
class OwnerGoingSummary {
  const OwnerGoingSummary({required this.count, required this.partySizes});

  final int count;
  final List<int> partySizes;
}
