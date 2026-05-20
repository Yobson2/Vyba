import 'package:flutter/foundation.dart';

/// Types of in-app notifications.
enum NotificationType {
  bookingConfirmed,
  promoNew,
  reviewReply,
  badgeEarned,
  bookingCompleted,
}

/// Domain entity representing an in-app notification.
@immutable
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  /// Unique notification identifier.
  final String id;

  /// Notification category — drives the icon and color.
  final NotificationType type;

  /// Short headline.
  final String title;

  /// Descriptive body text.
  final String body;

  /// Whether the user has already seen this notification.
  final bool isRead;

  /// Timestamp when the notification was created.
  final DateTime createdAt;

  /// Returns a copy with [isRead] set to `true`.
  AppNotification markRead() => AppNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        isRead: true,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppNotification &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
