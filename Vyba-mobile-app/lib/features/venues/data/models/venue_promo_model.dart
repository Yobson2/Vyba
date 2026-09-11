import 'package:flutter_templates/features/venues/domain/entities/venue_promo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue_promo_model.freezed.dart';
part 'venue_promo_model.g.dart';

@freezed
abstract class VenuePromoModel with _$VenuePromoModel {
  const VenuePromoModel._();

  const factory VenuePromoModel({
    required String id,
    required String title,
    required String description,
    required DateTime publishedAt,
  }) = _VenuePromoModel;

  factory VenuePromoModel.fromJson(Map<String, dynamic> json) =>
      _$VenuePromoModelFromJson(json);

  VenuePromo toEntity() => VenuePromo(
        id: id,
        title: title,
        description: description,
        publishedAt: publishedAt,
      );
}
