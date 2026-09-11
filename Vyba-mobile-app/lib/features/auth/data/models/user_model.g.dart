// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      role: json['role'] == null
          ? UserRole.client
          : const _UserRoleConverter().fromJson(json['role'] as String),
    );

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'role': const _UserRoleConverter().toJson(instance.role),
    };
