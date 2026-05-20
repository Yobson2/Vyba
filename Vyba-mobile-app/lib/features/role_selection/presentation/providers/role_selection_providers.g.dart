// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_selection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$roleRepositoryHash() => r'885534fc789c23f939b923cd3cf484b39be6687d';

/// See also [roleRepository].
@ProviderFor(roleRepository)
final roleRepositoryProvider = AutoDisposeProvider<RoleRepository>.internal(
  roleRepository,
  name: r'roleRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$roleRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RoleRepositoryRef = AutoDisposeProviderRef<RoleRepository>;
String _$setUserRoleUseCaseHash() =>
    r'a93323fb2638d640b878e12a81591db856d6b680';

/// See also [setUserRoleUseCase].
@ProviderFor(setUserRoleUseCase)
final setUserRoleUseCaseProvider =
    AutoDisposeProvider<SetUserRoleUseCase>.internal(
  setUserRoleUseCase,
  name: r'setUserRoleUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$setUserRoleUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SetUserRoleUseCaseRef = AutoDisposeProviderRef<SetUserRoleUseCase>;
String _$selectedRoleHash() => r'6f7e432487c1e8b0e4ae5a2542f0cab635b11ce2';

/// See also [SelectedRole].
@ProviderFor(SelectedRole)
final selectedRoleProvider =
    AutoDisposeNotifierProvider<SelectedRole, UserRole?>.internal(
  SelectedRole.new,
  name: r'selectedRoleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedRoleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRole = AutoDisposeNotifier<UserRole?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
