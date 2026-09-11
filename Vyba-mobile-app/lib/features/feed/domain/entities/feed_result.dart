import 'package:flutter/foundation.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';

/// One page of the ranked feed, plus whether it came from the offline cache.
@immutable
class FeedResult {
  const FeedResult({
    required this.items,
    required this.isFromCache,
    required this.hasMore,
  });

  final List<FeedItem> items;
  final bool isFromCache;
  final bool hasMore;
}
