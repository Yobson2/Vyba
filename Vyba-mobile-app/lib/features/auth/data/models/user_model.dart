import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for [User] with JSON serialization.
///
/// Maps between API JSON responses and the domain [User] entity.
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @Default(UserRole.client) UserRole role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to a domain [User] entity.
  User toEntity() => User(
        id: id,
        email: email,
        name: name,
        avatarUrl: avatarUrl,
        phoneNumber: phoneNumber,
        role: role,
      );

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        avatarUrl: user.avatarUrl,
        phoneNumber: user.phoneNumber,
        role: user.role,
      );
}
