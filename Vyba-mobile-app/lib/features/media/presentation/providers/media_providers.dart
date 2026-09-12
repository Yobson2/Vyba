import 'package:flutter_templates/core/providers/network_providers.dart';
import 'package:flutter_templates/features/media/data/datasources/media_remote_datasource.dart';
import 'package:flutter_templates/features/media/data/repositories/media_repository_impl.dart';
import 'package:flutter_templates/features/media/domain/repositories/media_repository.dart';
import 'package:flutter_templates/features/media/domain/usecases/get_venue_night_photos_usecase.dart';
import 'package:flutter_templates/features/media/domain/usecases/upload_venue_night_photo_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_providers.g.dart';

@Riverpod(keepAlive: true)
MediaRemoteDataSource mediaRemoteDataSource(MediaRemoteDataSourceRef ref) {
  return MediaRemoteDataSourceImpl(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
MediaRepository mediaRepository(MediaRepositoryRef ref) {
  return MediaRepositoryImpl(
    remoteDataSource: ref.watch(mediaRemoteDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}

@riverpod
UploadVenueNightPhotoUseCase uploadVenueNightPhotoUseCase(
  UploadVenueNightPhotoUseCaseRef ref,
) {
  return UploadVenueNightPhotoUseCase(ref.watch(mediaRepositoryProvider));
}

@riverpod
GetVenueNightPhotosUseCase getVenueNightPhotosUseCase(
  GetVenueNightPhotosUseCaseRef ref,
) {
  return GetVenueNightPhotosUseCase(ref.watch(mediaRepositoryProvider));
}
