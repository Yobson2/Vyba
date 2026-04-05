import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/notifications/data/datasources/mock_notification_datasource.dart';
import 'package:flutter_templates/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:flutter_templates/features/notifications/domain/entities/app_notification.dart';
import 'package:flutter_templates/features/notifications/domain/repositories/notification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_providers.g.dart';

// ---------------------------------------------------------------------------
// Data layer
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
MockNotificationDatasource notificationDatasource(
  NotificationDatasourceRef ref,
) {
  return MockNotificationDatasource();
}

@Riverpod(keepAlive: true)
NotificationRepository notificationRepository(
  NotificationRepositoryRef ref,
) {
  return NotificationRepositoryImpl(
    ref.watch(notificationDatasourceProvider),
  );
}

// ---------------------------------------------------------------------------
// Presentation state
// ---------------------------------------------------------------------------

@riverpod
Future<List<AppNotification>> notifications(NotificationsRef ref) async {
  final repo = ref.watch(notificationRepositoryProvider);
  final result = await repo.getNotifications();
  return result.fold(
    (Failure failure) => throw Exception(failure.message),
    (List<AppNotification> list) => list,
  );
}

@riverpod
class NotificationMarker extends _$NotificationMarker {
  @override
  FutureOr<void> build() {}

  Future<void> markAsRead(String id) async {
    final repo = ref.read(notificationRepositoryProvider);
    await repo.markAsRead(id);
    ref.invalidate(notificationsProvider);
  }
}
