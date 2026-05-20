import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/error/failures.dart';

abstract class RoleRepository {
  Future<Either<Failure, void>> setUserRole(UserRole role);
  Future<Either<Failure, UserRole?>> getUserRole();
}
