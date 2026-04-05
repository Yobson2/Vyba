// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokensModel _$TokensModelFromJson(Map<String, dynamic> json) => _TokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
    );

Map<String, dynamic> _$TokensModelToJson(_TokensModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
    };
