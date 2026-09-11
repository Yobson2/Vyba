import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/promotions/data/datasources/promo_remote_datasource.dart';
import 'package:flutter_templates/features/promotions/data/repositories/promo_repository_impl.dart';
import 'package:flutter_templates/features/promotions/domain/repositories/promo_repository.dart';
import 'package:flutter_templates/features/promotions/domain/usecases/create_promo_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promo_providers.g.dart';

@Riverpod(keepAlive: true)
PromoRemoteDataSource promoRemoteDataSource(PromoRemoteDataSourceRef ref) {
  return PromoRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
PromoRepository promoRepository(PromoRepositoryRef ref) {
  return PromoRepositoryImpl(
    remoteDataSource: ref.watch(promoRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
CreatePromoUseCase createPromoUseCase(CreatePromoUseCaseRef ref) {
  return CreatePromoUseCase(ref.watch(promoRepositoryProvider));
}
