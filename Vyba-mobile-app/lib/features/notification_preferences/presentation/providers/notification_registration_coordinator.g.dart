// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_registration_coordinator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationRegistrationCoordinatorHash() =>
    r'982190b13cabccedfaaa5274838827ab2a423cb5';

/// Registers/deregisters the device's push token against the backend as the
/// user signs in/out (ticket 15) — the token itself comes from
/// `PushNotificationService`, never queried directly by callers.
///
/// Copied from [notificationRegistrationCoordinator].
@ProviderFor(notificationRegistrationCoordinator)
final notificationRegistrationCoordinatorProvider =
    Provider<NotificationRegistrationCoordinator>.internal(
  notificationRegistrationCoordinator,
  name: r'notificationRegistrationCoordinatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationRegistrationCoordinatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationRegistrationCoordinatorRef
    = ProviderRef<NotificationRegistrationCoordinator>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
