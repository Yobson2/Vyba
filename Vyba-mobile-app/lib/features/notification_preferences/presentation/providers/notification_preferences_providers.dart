import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/notification_preferences/data/datasources/notification_preferences_remote_datasource.dart';
import 'package:flutter_templates/features/notification_preferences/data/repositories/notification_preferences_repository_impl.dart';
import 'package:flutter_templates/features/notification_preferences/domain/repositories/notification_preferences_repository.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/deregister_device_token_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/get_notification_preferences_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/register_device_token_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/set_notification_preferences_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_preferences_providers.g.dart';

@Riverpod(keepAlive: true)
NotificationPreferencesRemoteDataSource notificationPreferencesRemoteDataSource(
  NotificationPreferencesRemoteDataSourceRef ref,
) {
  return NotificationPreferencesRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
NotificationPreferencesRepository notificationPreferencesRepository(
  NotificationPreferencesRepositoryRef ref,
) {
  return NotificationPreferencesRepositoryImpl(
    remoteDataSource:
        ref.watch(notificationPreferencesRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
GetNotificationPreferencesUseCase getNotificationPreferencesUseCase(
  GetNotificationPreferencesUseCaseRef ref,
) {
  return GetNotificationPreferencesUseCase(
    ref.watch(notificationPreferencesRepositoryProvider),
  );
}

@riverpod
SetNotificationPreferencesUseCase setNotificationPreferencesUseCase(
  SetNotificationPreferencesUseCaseRef ref,
) {
  return SetNotificationPreferencesUseCase(
    ref.watch(notificationPreferencesRepositoryProvider),
  );
}

@riverpod
RegisterDeviceTokenUseCase registerDeviceTokenUseCase(
  RegisterDeviceTokenUseCaseRef ref,
) {
  return RegisterDeviceTokenUseCase(
    ref.watch(notificationPreferencesRepositoryProvider),
  );
}

@riverpod
DeregisterDeviceTokenUseCase deregisterDeviceTokenUseCase(
  DeregisterDeviceTokenUseCaseRef ref,
) {
  return DeregisterDeviceTokenUseCase(
    ref.watch(notificationPreferencesRepositoryProvider),
  );
}
