import 'package:flutter_templates/features/notifications/domain/entities/app_notification.dart';

/// Mock data source providing sample notifications for development.
class MockNotificationDatasource {
  MockNotificationDatasource() : _notifications = _buildSampleData();

  final List<AppNotification> _notifications;

  static List<AppNotification> _buildSampleData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    return [
      AppNotification(
        id: 'notif_1',
        type: NotificationType.bookingConfirmed,
        title: 'Booking Confirmed',
        body: 'Your reservation at Sky Lounge Abidjan is confirmed for Friday, 8 PM.',
        isRead: false,
        createdAt: today.add(const Duration(hours: 10, minutes: 45)),
      ),
      AppNotification(
        id: 'notif_2',
        type: NotificationType.reviewReply,
        title: 'Tunde O. replied to you',
        body: 'Thanks for the kind words! We hope to see you again at Lagoon Restaurant soon.',
        isRead: false,
        createdAt: today.add(const Duration(hours: 14, minutes: 15)),
      ),
      AppNotification(
        id: 'notif_3',
        type: NotificationType.promoNew,
        title: 'Exclusive Flash Sale',
        body: '50% off VIP tables at Quilox Nightclub this weekend only. Book now!',
        isRead: true,
        createdAt: yesterday.add(const Duration(hours: 18)),
      ),
      AppNotification(
        id: 'notif_4',
        type: NotificationType.bookingCompleted,
        title: 'Booking Completed',
        body: 'How was your visit to Sky Lounge Abidjan? Leave a review and earn points.',
        isRead: true,
        createdAt: yesterday.add(const Duration(hours: 11, minutes: 30)),
      ),
      AppNotification(
        id: 'notif_5',
        type: NotificationType.badgeEarned,
        title: 'New Badge Earned',
        body: 'You earned the "Night Owl" badge for visiting 5 venues after midnight.',
        isRead: true,
        createdAt: DateTime(now.year, 10, 24, 9),
      ),
    ];
  }

  /// Returns all notifications ordered by newest first.
  Future<List<AppNotification>> getNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.of(_notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Marks the notification with [id] as read.
  Future<void> markAsRead(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].markRead();
    }
  }
}
