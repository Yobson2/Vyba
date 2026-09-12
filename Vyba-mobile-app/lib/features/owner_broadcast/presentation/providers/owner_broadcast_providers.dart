import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/owner_broadcast/data/datasources/owner_broadcast_remote_datasource.dart';
import 'package:flutter_templates/features/owner_broadcast/data/repositories/owner_broadcast_repository_impl.dart';
import 'package:flutter_templates/features/owner_broadcast/domain/repositories/owner_broadcast_repository.dart';
import 'package:flutter_templates/features/owner_broadcast/domain/usecases/send_broadcast_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'owner_broadcast_providers.g.dart';

@Riverpod(keepAlive: true)
OwnerBroadcastRemoteDataSource ownerBroadcastRemoteDataSource(
  OwnerBroadcastRemoteDataSourceRef ref,
) {
  return OwnerBroadcastRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
OwnerBroadcastRepository ownerBroadcastRepository(
  OwnerBroadcastRepositoryRef ref,
) {
  return OwnerBroadcastRepositoryImpl(
    remoteDataSource: ref.watch(ownerBroadcastRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
SendBroadcastUseCase sendBroadcastUseCase(SendBroadcastUseCaseRef ref) {
  return SendBroadcastUseCase(ref.watch(ownerBroadcastRepositoryProvider));
}
