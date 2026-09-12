// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_promo_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$createPromoNotifierHash() =>
    r'dbfc7b15059adf8dea0f9bc77f7ecc308fbb9d37';

/// Drives the owner's create-promo form (ticket 09) — title + description,
/// published for the owner's own venue (known from
/// [venueNightNotifierProvider], already loaded on Accueil; avoids a second
/// "which venue is mine" round trip).
///
/// Copied from [CreatePromoNotifier].
@ProviderFor(CreatePromoNotifier)
final createPromoNotifierProvider =
    NotifierProvider<CreatePromoNotifier, CreatePromoState>.internal(
  CreatePromoNotifier.new,
  name: r'createPromoNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createPromoNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreatePromoNotifier = Notifier<CreatePromoState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
