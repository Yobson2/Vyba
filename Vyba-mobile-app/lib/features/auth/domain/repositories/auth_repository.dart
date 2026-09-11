import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';

/// Abstract authentication repository defined in the domain layer.
///
/// Implemented by [AuthRepositoryImpl] in the data layer. Phone-OTP is the
/// only identity primitive (ADR-0003): a request/verify pair, no
/// email/password path.
abstract class AuthRepository {
  /// Requests (or resends) an OTP code for [phoneNumber].
  Future<Either<Failure, void>> requestOtp({required String phoneNumber});

  /// Verifies the OTP [code] for [phoneNumber] and signs the user in.
  ///
  /// [ageConfirmed] is required on a first-ever verify (backend enforces
  /// this); omit or pass `false` on a returning sign-in.
  Future<Either<Failure, User>> verifyOtp({
    required String phoneNumber,
    required String code,
    bool? ageConfirmed,
  });

  /// Logs out the current user and clears local session state.
  Future<Either<Failure, void>> logout();

  /// Gets the currently cached user (from local storage), without
  /// validating the access token.
  Future<Either<Failure, User>> getCachedUser();

  /// Restores the session on cold start: returns the cached user directly if
  /// the access token is still valid, otherwise refreshes it first.
  Future<Either<Failure, User>> restoreSession();

  /// Whether a valid token exists locally.
  Future<bool> get isAuthenticated;
}
