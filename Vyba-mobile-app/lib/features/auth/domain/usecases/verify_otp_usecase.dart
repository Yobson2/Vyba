import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Verifies an OTP code sent to the user's email.
class VerifyOtpUseCase extends UseCase<void, VerifyOtpParams> {
  /// Creates a [VerifyOtpUseCase].
  const VerifyOtpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) {
    return _repository.verifyOtp(email: params.email, code: params.code);
  }
}

/// Parameters for [VerifyOtpUseCase].
class VerifyOtpParams {
  /// Creates [VerifyOtpParams].
  const VerifyOtpParams({required this.email, required this.code});

  /// User email.
  final String email;

  /// OTP code.
  final String code;
}
