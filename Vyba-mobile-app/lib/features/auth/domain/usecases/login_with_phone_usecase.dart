import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Authenticates a user with phone number and OTP code.
class LoginWithPhoneUseCase extends UseCase<User, LoginWithPhoneParams> {
  /// Creates a [LoginWithPhoneUseCase].
  const LoginWithPhoneUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(LoginWithPhoneParams params) {
    return _repository.loginWithPhone(
      phoneNumber: params.phoneNumber,
      code: params.code,
    );
  }
}

/// Parameters for [LoginWithPhoneUseCase].
class LoginWithPhoneParams {
  /// Creates [LoginWithPhoneParams].
  const LoginWithPhoneParams({required this.phoneNumber, required this.code});

  /// User phone number.
  final String phoneNumber;

  /// OTP code.
  final String code;
}
