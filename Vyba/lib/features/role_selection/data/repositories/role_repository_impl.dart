import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/storage/local_storage.dart';
import 'package:flutter_templates/features/role_selection/domain/repositories/role_repository.dart';

class RoleRepositoryImpl implements RoleRepository {
  RoleRepositoryImpl(this._localStorage);

  final LocalStorage _localStorage;
  static const _roleKey = 'user_role';

  @override
  Future<Either<Failure, void>> setUserRole(UserRole role) async {
    try {
      await _localStorage.setString(_roleKey, role.name);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to save user role'));
    }
  }

  @override
  Future<Either<Failure, UserRole?>> getUserRole() async {
    try {
      final roleStr = _localStorage.getString(_roleKey);
      if (roleStr == null) return const Right(null);
      final role = UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.client,
      );
      return Right(role);
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to read user role'));
    }
  }
}
