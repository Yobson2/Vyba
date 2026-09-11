import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/enums/user_role.dart';

/// Domain entity representing an authenticated user.
///
/// Identity is the phone number (ADR-0003) — there is no email or password.
/// This is a pure domain object with no framework dependencies.
@immutable
class User {
  /// Creates a [User].
  const User({
    required this.id,
    required this.phoneNumber,
    this.firstName,
    this.lastName,
    this.role = UserRole.client,
  });

  /// Unique identifier.
  final String id;

  /// E.164 phone number — the canonical identity.
  final String phoneNumber;

  /// Optional first name.
  final String? firstName;

  /// Optional last name.
  final String? lastName;

  /// User role (client or venue owner).
  final UserRole role;

  /// Full name if set, falling back to the phone number.
  String get displayName {
    final joined = [firstName, lastName]
        .whereType<String>()
        .where((part) => part.trim().isNotEmpty)
        .join(' ');
    return joined.isNotEmpty ? joined : phoneNumber;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phoneNumber == other.phoneNumber &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          role == other.role;

  @override
  int get hashCode => Object.hash(id, phoneNumber, firstName, lastName, role);

  @override
  String toString() => 'User(id: $id, phoneNumber: $phoneNumber, role: $role)';
}
