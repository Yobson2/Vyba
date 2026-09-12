// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pushNotificationServiceHash() =>
    r'a9b02ff1a9e19f06a294296d1ed98f3ca88be8e6';

/// The dev stand-in is wired here; a `FirebasePushNotificationService` slots
/// in behind the same interface once a real Firebase project exists (see
/// `PushNotificationService`'s doc comment) — no other code changes.
///
/// Copied from [pushNotificationService].
@ProviderFor(pushNotificationService)
final pushNotificationServiceProvider =
    Provider<PushNotificationService>.internal(
  pushNotificationService,
  name: r'pushNotificationServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pushNotificationServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PushNotificationServiceRef = ProviderRef<PushNotificationService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
