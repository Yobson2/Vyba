// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPreferencesNotifierHash() =>
    r'ce2eadab778ce7a629e27a6a77cfd44a7962eb4c';

/// Backs the "Préférences de notification" settings screen — optimistic
/// toggles with rollback on failure, mirroring `FollowNotifier` (ticket 10).
///
/// Copied from [NotificationPreferencesNotifier].
@ProviderFor(NotificationPreferencesNotifier)
final notificationPreferencesNotifierProvider = AutoDisposeNotifierProvider<
    NotificationPreferencesNotifier, NotificationPreferencesState>.internal(
  NotificationPreferencesNotifier.new,
  name: r'notificationPreferencesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPreferencesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationPreferencesNotifier
    = AutoDisposeNotifier<NotificationPreferencesState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
