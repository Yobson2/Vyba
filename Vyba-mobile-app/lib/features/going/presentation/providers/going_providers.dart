import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/going/data/datasources/going_remote_datasource.dart';
import 'package:flutter_templates/features/going/data/repositories/going_repository_impl.dart';
import 'package:flutter_templates/features/going/domain/repositories/going_repository.dart';
import 'package:flutter_templates/features/going/domain/usecases/cancel_going_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/get_mine_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/get_owner_going_summary_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/mark_going_usecase.dart';
import 'package:flutter_templates/features/going/domain/usecases/update_going_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'going_providers.g.dart';

@Riverpod(keepAlive: true)
GoingRemoteDataSource goingRemoteDataSource(GoingRemoteDataSourceRef ref) {
  return GoingRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
GoingRepository goingRepository(GoingRepositoryRef ref) {
  return GoingRepositoryImpl(
    remoteDataSource: ref.watch(goingRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
GetMineUseCase getMineUseCase(GetMineUseCaseRef ref) {
  return GetMineUseCase(ref.watch(goingRepositoryProvider));
}

@riverpod
MarkGoingUseCase markGoingUseCase(MarkGoingUseCaseRef ref) {
  return MarkGoingUseCase(ref.watch(goingRepositoryProvider));
}

@riverpod
UpdateGoingUseCase updateGoingUseCase(UpdateGoingUseCaseRef ref) {
  return UpdateGoingUseCase(ref.watch(goingRepositoryProvider));
}

@riverpod
CancelGoingUseCase cancelGoingUseCase(CancelGoingUseCaseRef ref) {
  return CancelGoingUseCase(ref.watch(goingRepositoryProvider));
}

@riverpod
GetOwnerGoingSummaryUseCase getOwnerGoingSummaryUseCase(
  GetOwnerGoingSummaryUseCaseRef ref,
) {
  return GetOwnerGoingSummaryUseCase(ref.watch(goingRepositoryProvider));
}
