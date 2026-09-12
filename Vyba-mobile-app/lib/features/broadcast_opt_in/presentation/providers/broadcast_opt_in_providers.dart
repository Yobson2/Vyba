import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/broadcast_opt_in/data/datasources/broadcast_opt_in_remote_datasource.dart';
import 'package:flutter_templates/features/broadcast_opt_in/data/repositories/broadcast_opt_in_repository_impl.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/repositories/broadcast_opt_in_repository.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/get_my_opt_ins_usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/is_opted_in_usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/opt_in_usecase.dart';
import 'package:flutter_templates/features/broadcast_opt_in/domain/usecases/opt_out_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'broadcast_opt_in_providers.g.dart';

@Riverpod(keepAlive: true)
BroadcastOptInRemoteDataSource broadcastOptInRemoteDataSource(
  BroadcastOptInRemoteDataSourceRef ref,
) {
  return BroadcastOptInRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
BroadcastOptInRepository broadcastOptInRepository(
  BroadcastOptInRepositoryRef ref,
) {
  return BroadcastOptInRepositoryImpl(
    remoteDataSource: ref.watch(broadcastOptInRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
IsOptedInUseCase isOptedInUseCase(IsOptedInUseCaseRef ref) {
  return IsOptedInUseCase(ref.watch(broadcastOptInRepositoryProvider));
}

@riverpod
OptInUseCase optInUseCase(OptInUseCaseRef ref) {
  return OptInUseCase(ref.watch(broadcastOptInRepositoryProvider));
}

@riverpod
OptOutUseCase optOutUseCase(OptOutUseCaseRef ref) {
  return OptOutUseCase(ref.watch(broadcastOptInRepositoryProvider));
}

@riverpod
GetMyOptInsUseCase getMyOptInsUseCase(GetMyOptInsUseCaseRef ref) {
  return GetMyOptInsUseCase(ref.watch(broadcastOptInRepositoryProvider));
}
