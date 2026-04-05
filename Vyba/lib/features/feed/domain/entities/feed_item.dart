import 'package:flutter/foundation.dart';

sealed class FeedItem {
  const FeedItem({required this.id, required this.createdAt});
  final String id;
  final DateTime createdAt;
}

@immutable
class PromoFeedItem extends FeedItem {
  const PromoFeedItem({
    required super.id,
    required super.createdAt,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.venueName,
    this.validUntil,
    this.promoType = 'discount',
  });

  final String title;
  final String description;
  final String imageUrl;
  final String venueName;
  final DateTime? validUntil;
  final String promoType;
}

@immutable
class EventFeedItem extends FeedItem {
  const EventFeedItem({
    required super.id,
    required super.createdAt,
    required this.title,
    required this.imageUrl,
    required this.venueName,
    required this.date,
    this.attendeeCount = 0,
    this.attendeeAvatars = const [],
    this.isInterested = false,
  });

  final String title;
  final String imageUrl;
  final String venueName;
  final DateTime date;
  final int attendeeCount;
  final List<String> attendeeAvatars;
  final bool isInterested;
}
