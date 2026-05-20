import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Sends a password reset code to the user's email.
class ForgotPasswordUseCase extends UseCase<void, ForgotPasswordParams> {
  /// Creates a [ForgotPasswordUseCase].
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) {
    return _repository.forgotPassword(email: params.email);
  }
}

/// Parameters for [ForgotPasswordUseCase].
class ForgotPasswordParams {
  /// Creates [ForgotPasswordParams].
  const ForgotPasswordParams({required this.email});

  /// Email to send the reset code to.
  final String email;
}
