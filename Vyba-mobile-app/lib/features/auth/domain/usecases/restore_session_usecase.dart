import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/auth/domain/entities/user.dart';
import 'package:flutter_templates/features/auth/domain/repositories/auth_repository.dart';

/// Restores the session on cold start, refreshing the access token first if
/// it has expired (CLAUDE.md: validate `exp` client-side, don't rely on 401s).
class RestoreSessionUseCase extends UseCase<User, NoParams> {
  /// Creates a [RestoreSessionUseCase].
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return _repository.restoreSession();
  }
}
