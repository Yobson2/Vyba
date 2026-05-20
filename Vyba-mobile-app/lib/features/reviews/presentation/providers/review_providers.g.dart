// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewDatasourceHash() => r'f2ab4a624e621cb1c6ef73e710be551422eee44d';

/// See also [reviewDatasource].
@ProviderFor(reviewDatasource)
final reviewDatasourceProvider = Provider<MockReviewDatasource>.internal(
  reviewDatasource,
  name: r'reviewDatasourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewDatasourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewDatasourceRef = ProviderRef<MockReviewDatasource>;
String _$reviewRepositoryHash() => r'0d85fea94ba5c57e8dccd45305d62ca809dda47b';

/// See also [reviewRepository].
@ProviderFor(reviewRepository)
final reviewRepositoryProvider = Provider<ReviewRepository>.internal(
  reviewRepository,
  name: r'reviewRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewRepositoryRef = ProviderRef<ReviewRepository>;
String _$submitReviewUseCaseHash() =>
    r'85cb2789d5e13064e91fa728c95534d01cb90040';

/// See also [submitReviewUseCase].
@ProviderFor(submitReviewUseCase)
final submitReviewUseCaseProvider = Provider<SubmitReviewUseCase>.internal(
  submitReviewUseCase,
  name: r'submitReviewUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$submitReviewUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubmitReviewUseCaseRef = ProviderRef<SubmitReviewUseCase>;
String _$venueReviewsHash() => r'93a9e3a046985d0e11d3d4e3ed13848b03144c46';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [venueReviews].
@ProviderFor(venueReviews)
const venueReviewsProvider = VenueReviewsFamily();

/// See also [venueReviews].
class VenueReviewsFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [venueReviews].
  const VenueReviewsFamily();

  /// See also [venueReviews].
  VenueReviewsProvider call(
    String venueId,
  ) {
    return VenueReviewsProvider(
      venueId,
    );
  }

  @override
  VenueReviewsProvider getProviderOverride(
    covariant VenueReviewsProvider provider,
  ) {
    return call(
      provider.venueId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'venueReviewsProvider';
}

/// See also [venueReviews].
class VenueReviewsProvider extends AutoDisposeFutureProvider<List<Review>> {
  /// See also [venueReviews].
  VenueReviewsProvider(
    String venueId,
  ) : this._internal(
          (ref) => venueReviews(
            ref as VenueReviewsRef,
            venueId,
          ),
          from: venueReviewsProvider,
          name: r'venueReviewsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$venueReviewsHash,
          dependencies: VenueReviewsFamily._dependencies,
          allTransitiveDependencies:
              VenueReviewsFamily._allTransitiveDependencies,
          venueId: venueId,
        );

  VenueReviewsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.venueId,
  }) : super.internal();

  final String venueId;

  @override
  Override overrideWith(
    FutureOr<List<Review>> Function(VenueReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: VenueReviewsProvider._internal(
        (ref) => create(ref as VenueReviewsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        venueId: venueId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Review>> createElement() {
    return _VenueReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VenueReviewsProvider && other.venueId == venueId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, venueId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VenueReviewsRef on AutoDisposeFutureProviderRef<List<Review>> {
  /// The parameter `venueId` of this provider.
  String get venueId;
}

class _VenueReviewsProviderElement
    extends AutoDisposeFutureProviderElement<List<Review>>
    with VenueReviewsRef {
  _VenueReviewsProviderElement(super.provider);

  @override
  String get venueId => (origin as VenueReviewsProvider).venueId;
}

String _$reviewSubmitterHash() => r'6c2dbb7afe2b9e8a4d1b6aaf0bb4c3335b2ea20b';

/// See also [ReviewSubmitter].
@ProviderFor(ReviewSubmitter)
final reviewSubmitterProvider =
    AutoDisposeAsyncNotifierProvider<ReviewSubmitter, Review?>.internal(
  ReviewSubmitter.new,
  name: r'reviewSubmitterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewSubmitterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReviewSubmitter = AutoDisposeAsyncNotifier<Review?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
