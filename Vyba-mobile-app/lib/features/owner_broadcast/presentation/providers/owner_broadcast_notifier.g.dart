// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_broadcast_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ownerBroadcastNotifierHash() =>
    r'ff4f374fe7b9967f00799816fb7e16ef5ab66822';

/// Drives "prévenir ceux qui viennent ce soir" (ticket 17) — the owner's
/// venue comes from [venueNightNotifierProvider], already loaded on Accueil,
/// same seam `CreatePromoNotifier` uses.
///
/// Copied from [OwnerBroadcastNotifier].
@ProviderFor(OwnerBroadcastNotifier)
final ownerBroadcastNotifierProvider =
    NotifierProvider<OwnerBroadcastNotifier, OwnerBroadcastState>.internal(
  OwnerBroadcastNotifier.new,
  name: r'ownerBroadcastNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ownerBroadcastNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OwnerBroadcastNotifier = Notifier<OwnerBroadcastState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
