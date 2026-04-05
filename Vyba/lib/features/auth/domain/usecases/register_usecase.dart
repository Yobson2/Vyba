import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Registers a new user account.
class RegisterUseCase extends UseCase<User, RegisterParams> {
  /// Creates a [RegisterUseCase].
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(RegisterParams params) {
    return _repository.register(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

/// Parameters for [RegisterUseCase].
class RegisterParams {
  /// Creates [RegisterParams].
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  /// User display name.
  final String name;

  /// User email.
  final String email;

  /// User password.
  final String password;
}
