// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationDatasourceHash() =>
    r'cc22fa48d908e3be60616421687c6f171b2db67e';

/// See also [notificationDatasource].
@ProviderFor(notificationDatasource)
final notificationDatasourceProvider =
    Provider<MockNotificationDatasource>.internal(
  notificationDatasource,
  name: r'notificationDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationDatasourceRef = ProviderRef<MockNotificationDatasource>;
String _$notificationRepositoryHash() =>
    r'1828b8e918525e1adebe9b43e222887e19fafb76';

/// See also [notificationRepository].
@ProviderFor(notificationRepository)
final notificationRepositoryProvider =
    Provider<NotificationRepository>.internal(
  notificationRepository,
  name: r'notificationRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRepositoryRef = ProviderRef<NotificationRepository>;
String _$notificationsHash() => r'54cfbb564d5414fa9a03f0a3ee5806880e18e97f';

/// See also [notifications].
@ProviderFor(notifications)
final notificationsProvider =
    AutoDisposeFutureProvider<List<AppNotification>>.internal(
  notifications,
  name: r'notificationsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationsRef = AutoDisposeFutureProviderRef<List<AppNotification>>;
String _$notificationMarkerHash() =>
    r'9c24fe4eb541a245ceac4105e49f118bc5bc3ef2';

/// See also [NotificationMarker].
@ProviderFor(NotificationMarker)
final notificationMarkerProvider =
    AutoDisposeAsyncNotifierProvider<NotificationMarker, void>.internal(
  NotificationMarker.new,
  name: r'notificationMarkerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationMarkerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationMarker = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
