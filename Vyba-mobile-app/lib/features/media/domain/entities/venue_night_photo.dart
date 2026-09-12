import 'package:flutter/foundation.dart';

@immutable
class VenueNightPhoto {
  const VenueNightPhoto({
    required this.id,
    required this.url,
    required this.thumbnailUrl,
  });

  final String id;
  final String url;
  final String thumbnailUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VenueNightPhoto &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          thumbnailUrl == other.thumbnailUrl;

  @override
  int get hashCode => Object.hash(id, url, thumbnailUrl);
}
