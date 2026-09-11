import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data model for [User] with JSON serialization.
///
/// Maps between the backend's phone-first `User` JSON (ADR-0003) and the
/// domain [User] entity.
@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String phone,
    String? firstName,
    String? lastName,
    @_UserRoleConverter() @Default(UserRole.client) UserRole role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Converts this model to a domain [User] entity.
  User toEntity() => User(
        id: id,
        phoneNumber: phone,
        firstName: firstName,
        lastName: lastName,
        role: role,
      );

  /// Creates a [UserModel] from a domain [User] entity.
  factory UserModel.fromEntity(User user) => UserModel(
        id: user.id,
        phone: user.phoneNumber,
        firstName: user.firstName,
        lastName: user.lastName,
        role: user.role,
      );
}

/// Maps the backend's `ADMIN` / `VENUE_OWNER` / `CLIENT` role strings to
/// [UserRole]. `ADMIN` has no mobile shell and falls back to `client`.
class _UserRoleConverter implements JsonConverter<UserRole, String> {
  const _UserRoleConverter();

  @override
  UserRole fromJson(String json) => switch (json) {
        'VENUE_OWNER' => UserRole.venueOwner,
        _ => UserRole.client,
      };

  @override
  String toJson(UserRole role) => switch (role) {
        UserRole.venueOwner => 'VENUE_OWNER',
        UserRole.client => 'CLIENT',
      };
}
