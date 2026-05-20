import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/notifications/domain/entities/app_notification.dart';

/// Abstract contract for notification data operations.
abstract class NotificationRepository {
  /// Returns all notifications for the current user.
  Future<Either<Failure, List<AppNotification>>> getNotifications();

  /// Marks a single notification as read.
  Future<Either<Failure, void>> markAsRead(String id);
}
