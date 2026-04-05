import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/enums/user_role.dart';

/// Domain entity representing an authenticated user.
///
/// This is a pure domain object with no framework dependencies.
@immutable
class User {
  /// Creates a [User].
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.phoneNumber,
    this.role = UserRole.client,
  });

  /// Unique identifier.
  final String id;

  /// User email address.
  final String email;

  /// Display name.
  final String name;

  /// Optional avatar image URL.
  final String? avatarUrl;

  /// Optional phone number.
  final String? phoneNumber;

  /// User role (client or venue owner).
  final UserRole role;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          avatarUrl == other.avatarUrl &&
          phoneNumber == other.phoneNumber &&
          role == other.role;

  @override
  int get hashCode =>
      Object.hash(id, email, name, avatarUrl, phoneNumber, role);

  @override
  String toString() =>
      'User(id: $id, email: $email, name: $name, role: $role)';
}
