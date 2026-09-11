import 'package:flutter_templates/features/auth/domain/entities/tokens.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tokens_model.freezed.dart';
part 'tokens_model.g.dart';

/// Data model for [Tokens] with JSON serialization.
@freezed
abstract class TokensModel with _$TokensModel {
  /// Creates a [TokensModel].
  const TokensModel._();

  const factory TokensModel({
    required String accessToken,
    required String refreshToken,
  }) = _TokensModel;

  /// Creates a [TokensModel] from JSON.
  factory TokensModel.fromJson(Map<String, dynamic> json) =>
      _$TokensModelFromJson(json);

  /// Converts to domain [Tokens] entity.
  Tokens toEntity() => Tokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}
