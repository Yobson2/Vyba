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
  });

  /// E.164 phone number.
  final String phoneNumber;

  /// 6-digit OTP code.
  final String code;

  /// 18+ confirmation. Required on a first-ever verify.
  final bool? ageConfirmed;
}
