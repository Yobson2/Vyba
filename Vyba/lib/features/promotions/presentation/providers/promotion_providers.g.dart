// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$promotionDataSourceHash() =>
    r'109e50ea99e754f3d7860cae72a1b3ee51850dee';

/// See also [promotionDataSource].
@ProviderFor(promotionDataSource)
final promotionDataSourceProvider = Provider<PromotionDataSource>.internal(
  promotionDataSource,
  name: r'promotionDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promotionDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromotionDataSourceRef = ProviderRef<PromotionDataSource>;
String _$promotionRepositoryHash() =>
    r'b3735ae2208d3c5d00388ce2b08bb3a4e4d71e1d';

/// See also [promotionRepository].
@ProviderFor(promotionRepository)
final promotionRepositoryProvider = Provider<PromotionRepository>.internal(
  promotionRepository,
  name: r'promotionRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promotionRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PromotionRepositoryRef = ProviderRef<PromotionRepository>;
String _$myPromotionsHash() => r'3060ab2f6bf73bfa6fc89872695b57e86241fb62';

/// See also [myPromotions].
@ProviderFor(myPromotions)
final myPromotionsProvider =
    AutoDisposeFutureProvider<List<Promotion>>.internal(
  myPromotions,
  name: r'myPromotionsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$myPromotionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MyPromotionsRef = AutoDisposeFutureProviderRef<List<Promotion>>;
String _$createPromotionNotifierHash() =>
    r'a127da271e35dede20e28acf9f412cd3b5a43a0a';

/// See also [CreatePromotionNotifier].
@ProviderFor(CreatePromotionNotifier)
final createPromotionNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CreatePromotionNotifier, void>.internal(
  CreatePromotionNotifier.new,
  name: r'createPromotionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createPromotionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CreatePromotionNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
