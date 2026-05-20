import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Represents the authentication state of the application.
@freezed
sealed class AuthState with _$AuthState {
  /// Initial state before any auth check.
  const factory AuthState.initial() = AuthInitial;

  /// Loading state during auth operations.
  const factory AuthState.loading() = AuthLoading;

  /// User is authenticated.
  const factory AuthState.authenticated(User user) = AuthAuthenticated;

  /// User is not authenticated.
  const factory AuthState.unauthenticated() = AuthUnauthenticated;

  /// An error occurred during an auth operation.
  const factory AuthState.error(String message) = AuthError;
}
