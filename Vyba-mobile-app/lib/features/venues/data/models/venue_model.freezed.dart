// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VenueModel {
  String get id;
  String get name;
  String get description;
  String get address;
  double get latitude;
  double get longitude;
  @JsonKey(name: 'hero_images')
  List<String> get heroImages;
  double get rating;
  @JsonKey(name: 'review_count')
  int get reviewCount;
  @JsonKey(name: 'is_open')
  bool get isOpen;
  @JsonKey(name: 'venue_type')
  String get venueType;
  String? get phone;
  @JsonKey(name: 'opening_hours')
  String? get openingHours;
  @JsonKey(name: 'price_level')
  int get priceLevel;
  List<String> get amenities;
  @JsonKey(name: 'is_premium')
  bool get isPremium;
  @JsonKey(name: 'has_vip_pass')
  bool get hasVipPass;
  double? get distance;
  @JsonKey(name: 'active_promo_label')
  String? get activePromoLabel;

  /// Create a copy of VenueModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VenueModelCopyWith<VenueModel> get copyWith =>
      _$VenueModelCopyWithImpl<VenueModel>(this as VenueModel, _$identity);

  /// Serializes this VenueModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VenueModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality()
                .equals(other.heroImages, heroImages) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.venueType, venueType) ||
                other.venueType == venueType) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            const DeepCollectionEquality().equals(other.amenities, amenities) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.hasVipPass, hasVipPass) ||
                other.hasVipPass == hasVipPass) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.activePromoLabel, activePromoLabel) ||
                other.activePromoLabel == activePromoLabel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        address,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(heroImages),
        rating,
        reviewCount,
        isOpen,
        venueType,
        phone,
        openingHours,
        priceLevel,
        const DeepCollectionEquality().hash(amenities),
        isPremium,
        hasVipPass,
        distance,
        activePromoLabel
      ]);

  @override
  String toString() {
    return 'VenueModel(id: $id, name: $name, description: $description, address: $address, latitude: $latitude, longitude: $longitude, heroImages: $heroImages, rating: $rating, reviewCount: $reviewCount, isOpen: $isOpen, venueType: $venueType, phone: $phone, openingHours: $openingHours, priceLevel: $priceLevel, amenities: $amenities, isPremium: $isPremium, hasVipPass: $hasVipPass, distance: $distance, activePromoLabel: $activePromoLabel)';
  }
}

/// @nodoc
abstract mixin class $VenueModelCopyWith<$Res> {
  factory $VenueModelCopyWith(
          VenueModel value, $Res Function(VenueModel) _then) =
      _$VenueModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String address,
      double latitude,
      double longitude,
      @JsonKey(name: 'hero_images') List<String> heroImages,
      double rating,
      @JsonKey(name: 'review_count') int reviewCount,
      @JsonKey(name: 'is_open') bool isOpen,
      @JsonKey(name: 'venue_type') String venueType,
      String? phone,
      @JsonKey(name: 'opening_hours') String? openingHours,
      @JsonKey(name: 'price_level') int priceLevel,
      List<String> amenities,
      @JsonKey(name: 'is_premium') bool isPremium,
      @JsonKey(name: 'has_vip_pass') bool hasVipPass,
      double? distance,
      @JsonKey(name: 'active_promo_label') String? activePromoLabel});
}

/// @nodoc
class _$VenueModelCopyWithImpl<$Res> implements $VenueModelCopyWith<$Res> {
  _$VenueModelCopyWithImpl(this._self, this._then);

  final VenueModel _self;
  final $Res Function(VenueModel) _then;

  /// Create a copy of VenueModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? heroImages = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isOpen = null,
    Object? venueType = null,
    Object? phone = freezed,
    Object? openingHours = freezed,
    Object? priceLevel = null,
    Object? amenities = null,
    Object? isPremium = null,
    Object? hasVipPass = null,
    Object? distance = freezed,
    Object? activePromoLabel = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      heroImages: null == heroImages
          ? _self.heroImages
          : heroImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _self.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOpen: null == isOpen
          ? _self.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      venueType: null == venueType
          ? _self.venueType
          : venueType // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _self.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
      priceLevel: null == priceLevel
          ? _self.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _self.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPremium: null == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      hasVipPass: null == hasVipPass
          ? _self.hasVipPass
          : hasVipPass // ignore: cast_nullable_to_non_nullable
              as bool,
      distance: freezed == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      activePromoLabel: freezed == activePromoLabel
          ? _self.activePromoLabel
          : activePromoLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _VenueModel extends VenueModel {
  const _VenueModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.address,
      required this.latitude,
      required this.longitude,
      @JsonKey(name: 'hero_images') required final List<String> heroImages,
      required this.rating,
      @JsonKey(name: 'review_count') required this.reviewCount,
      @JsonKey(name: 'is_open') required this.isOpen,
      @JsonKey(name: 'venue_type') required this.venueType,
      this.phone,
      @JsonKey(name: 'opening_hours') this.openingHours,
      @JsonKey(name: 'price_level') this.priceLevel = 2,
      final List<String> amenities = const [],
      @JsonKey(name: 'is_premium') this.isPremium = false,
      @JsonKey(name: 'has_vip_pass') this.hasVipPass = false,
      this.distance,
      @JsonKey(name: 'active_promo_label') this.activePromoLabel})
      : _heroImages = heroImages,
        _amenities = amenities,
        super._();
  factory _VenueModel.fromJson(Map<String, dynamic> json) =>
      _$VenueModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  final List<String> _heroImages;
  @override
  @JsonKey(name: 'hero_images')
  List<String> get heroImages {
    if (_heroImages is EqualUnmodifiableListView) return _heroImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_heroImages);
  }

  @override
  final double rating;
  @override
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @override
  @JsonKey(name: 'is_open')
  final bool isOpen;
  @override
  @JsonKey(name: 'venue_type')
  final String venueType;
  @override
  final String? phone;
  @override
  @JsonKey(name: 'opening_hours')
  final String? openingHours;
  @override
  @JsonKey(name: 'price_level')
  final int priceLevel;
  final List<String> _amenities;
  @override
  @JsonKey()
  List<String> get amenities {
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amenities);
  }

  @override
  @JsonKey(name: 'is_premium')
  final bool isPremium;
  @override
  @JsonKey(name: 'has_vip_pass')
  final bool hasVipPass;
  @override
  final double? distance;
  @override
  @JsonKey(name: 'active_promo_label')
  final String? activePromoLabel;

  /// Create a copy of VenueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VenueModelCopyWith<_VenueModel> get copyWith =>
      __$VenueModelCopyWithImpl<_VenueModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VenueModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VenueModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality()
                .equals(other._heroImages, _heroImages) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.venueType, venueType) ||
                other.venueType == venueType) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.hasVipPass, hasVipPass) ||
                other.hasVipPass == hasVipPass) &&
            (identical(other.distance, distance) ||
                other.distance == distance) &&
            (identical(other.activePromoLabel, activePromoLabel) ||
                other.activePromoLabel == activePromoLabel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        address,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(_heroImages),
        rating,
        reviewCount,
        isOpen,
        venueType,
        phone,
        openingHours,
        priceLevel,
        const DeepCollectionEquality().hash(_amenities),
        isPremium,
        hasVipPass,
        distance,
        activePromoLabel
      ]);

  @override
  String toString() {
    return 'VenueModel(id: $id, name: $name, description: $description, address: $address, latitude: $latitude, longitude: $longitude, heroImages: $heroImages, rating: $rating, reviewCount: $reviewCount, isOpen: $isOpen, venueType: $venueType, phone: $phone, openingHours: $openingHours, priceLevel: $priceLevel, amenities: $amenities, isPremium: $isPremium, hasVipPass: $hasVipPass, distance: $distance, activePromoLabel: $activePromoLabel)';
  }
}

/// @nodoc
abstract mixin class _$VenueModelCopyWith<$Res>
    implements $VenueModelCopyWith<$Res> {
  factory _$VenueModelCopyWith(
          _VenueModel value, $Res Function(_VenueModel) _then) =
      __$VenueModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String address,
      double latitude,
      double longitude,
      @JsonKey(name: 'hero_images') List<String> heroImages,
      double rating,
      @JsonKey(name: 'review_count') int reviewCount,
      @JsonKey(name: 'is_open') bool isOpen,
      @JsonKey(name: 'venue_type') String venueType,
      String? phone,
      @JsonKey(name: 'opening_hours') String? openingHours,
      @JsonKey(name: 'price_level') int priceLevel,
      List<String> amenities,
      @JsonKey(name: 'is_premium') bool isPremium,
      @JsonKey(name: 'has_vip_pass') bool hasVipPass,
      double? distance,
      @JsonKey(name: 'active_promo_label') String? activePromoLabel});
}

/// @nodoc
class __$VenueModelCopyWithImpl<$Res> implements _$VenueModelCopyWith<$Res> {
  __$VenueModelCopyWithImpl(this._self, this._then);

  final _VenueModel _self;
  final $Res Function(_VenueModel) _then;

  /// Create a copy of VenueModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? address = null,
    Object? latitude = null,
    Object? longitude = null,
    Object? heroImages = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? isOpen = null,
    Object? venueType = null,
    Object? phone = freezed,
    Object? openingHours = freezed,
    Object? priceLevel = null,
    Object? amenities = null,
    Object? isPremium = null,
    Object? hasVipPass = null,
    Object? distance = freezed,
    Object? activePromoLabel = freezed,
  }) {
    return _then(_VenueModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: null == latitude
          ? _self.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double,
      longitude: null == longitude
          ? _self.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double,
      heroImages: null == heroImages
          ? _self._heroImages
          : heroImages // ignore: cast_nullable_to_non_nullable
              as List<String>,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _self.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      isOpen: null == isOpen
          ? _self.isOpen
          : isOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      venueType: null == venueType
          ? _self.venueType
          : venueType // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _self.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _self.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as String?,
      priceLevel: null == priceLevel
          ? _self.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int,
      amenities: null == amenities
          ? _self._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isPremium: null == isPremium
          ? _self.isPremium
          : isPremium // ignore: cast_nullable_to_non_nullable
              as bool,
      hasVipPass: null == hasVipPass
          ? _self.hasVipPass
          : hasVipPass // ignore: cast_nullable_to_non_nullable
              as bool,
      distance: freezed == distance
          ? _self.distance
          : distance // ignore: cast_nullable_to_non_nullable
              as double?,
      activePromoLabel: freezed == activePromoLabel
          ? _self.activePromoLabel
          : activePromoLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
