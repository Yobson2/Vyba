import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/notifications/data/datasources/mock_notification_datasource.dart';
import 'package:flutter_templates/features/notifications/domain/entities/app_notification.dart';
import 'package:flutter_templates/features/notifications/domain/repositories/notification_repository.dart';

/// Implementation of [NotificationRepository] backed by [MockNotificationDatasource].
class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._datasource);

  final MockNotificationDatasource _datasource;

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    try {
      final notifications = await _datasource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to load notifications'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _datasource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to mark notification as read'),
      );
    }
  }
}
