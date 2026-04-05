import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/features/role_selection/data/repositories/role_repository_impl.dart';
import 'package:flutter_templates/features/role_selection/domain/repositories/role_repository.dart';
import 'package:flutter_templates/features/role_selection/domain/usecases/set_user_role_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'role_selection_providers.g.dart';

@riverpod
RoleRepository roleRepository(RoleRepositoryRef ref) {
  return RoleRepositoryImpl(ref.read(localStorageProvider));
}

@riverpod
SetUserRoleUseCase setUserRoleUseCase(SetUserRoleUseCaseRef ref) {
  return SetUserRoleUseCase(ref.read(roleRepositoryProvider));
}

@riverpod
class SelectedRole extends _$SelectedRole {
  @override
  UserRole? build() => null;

  void select(UserRole role) => state = role;
}
