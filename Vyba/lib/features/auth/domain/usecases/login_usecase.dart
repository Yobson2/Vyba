import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Authenticates a user with email and password.
class LoginUseCase extends UseCase<User, LoginParams> {
  /// Creates a [LoginUseCase].
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}

/// Parameters for [LoginUseCase].
class LoginParams {
  /// Creates [LoginParams].
  const LoginParams({required this.email, required this.password});

  /// User email.
  final String email;

  /// User password.
  final String password;
}
