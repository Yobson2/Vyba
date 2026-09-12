import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Verifies an OTP code and signs the user in.
class VerifyOtpUseCase extends UseCase<User, VerifyOtpParams> {
  /// Creates a [VerifyOtpUseCase].
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(
      phoneNumber: params.phoneNumber,
      code: params.code,
      ageConfirmed: params.ageConfirmed,
      clientId: params.clientId,
    );
  }
}

/// Parameters for [VerifyOtpUseCase].
class VerifyOtpParams {
  /// Creates [VerifyOtpParams].
  const VerifyOtpParams({
    required this.phoneNumber,
    required this.code,
    this.ageConfirmed,
    this.clientId,
  });

  /// E.164 phone number.
  final String phoneNumber;

  /// 6-digit OTP code.
  final String code;

  /// 18+ confirmation. Required on a first-ever verify.
  final bool? ageConfirmed;

  /// Anonymous per-install client id — lets a first-ever signup be matched
  /// to a pending landing (ticket 11 / spec 07). Ignored on a resumed
  /// session (the backend only reads it on a brand-new account).
  final String? clientId;
}
