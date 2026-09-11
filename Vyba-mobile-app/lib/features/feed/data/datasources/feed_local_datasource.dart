import 'dart:convert';

import 'package:flutter_templates/core/storage/local_storage.dart';

/// Last-known-good feed page, for offline display (spec 11: "render the
/// cached list with a subtle 'hors ligne' indicator"). Only page 1 is
/// cached — there's nothing to page through offline anyway.
abstract class FeedLocalDataSource {
  Future<void> cacheFeed(List<Map<String, dynamic>> items);
  List<Map<String, dynamic>>? getCachedFeed();
}

class FeedLocalDataSourceImpl implements FeedLocalDataSource {
  const FeedLocalDataSourceImpl(this._localStorage);

  final LocalStorage _localStorage;

  static const _cacheKey = 'cached_feed_v1';

  @override
  Future<void> cacheFeed(List<Map<String, dynamic>> items) async {
    await _localStorage.setString(_cacheKey, json.encode(items));
  }

  @override
  List<Map<String, dynamic>>? getCachedFeed() {
    final raw = _localStorage.getString(_cacheKey);
    if (raw == null) return null;
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (_) {
      return null;
    }
  }
}
