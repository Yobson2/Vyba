import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/role_selection/domain/repositories/role_repository.dart';

class SetUserRoleUseCase extends UseCase<void, UserRole> {
  SetUserRoleUseCase(this._repository);

  final RoleRepository _repository;

  @override
  Future<Either<Failure, void>> call(UserRole params) {
    return _repository.setUserRole(params);
  }
}
