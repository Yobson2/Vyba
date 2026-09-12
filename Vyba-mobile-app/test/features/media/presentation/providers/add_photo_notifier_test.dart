import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/media/domain/entities/venue_night_photo.dart';
import 'package:flutter_templates/features/media/domain/usecases/upload_venue_night_photo_usecase.dart';
import 'package:flutter_templates/features/media/presentation/providers/add_photo_notifier.dart';
import 'package:flutter_templates/features/media/presentation/providers/add_photo_state.dart';
import 'package:flutter_templates/features/media/presentation/providers/media_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockUploadVenueNightPhotoUseCase mockUploadUseCase;

  const venueId = 'venue-1';
  const filePath = '/tmp/photo.jpg';
  const uploaded = VenueNightPhoto(
    id: 'photo-1',
    url: 'https://cdn.example/photo.jpg',
    thumbnailUrl: 'https://cdn.example/photo-thumb.jpg',
  );

  setUp(() {
    mockUploadUseCase = MockUploadVenueNightPhotoUseCase();
  });

  setUpAll(() {
    registerFallbackValue(
      const UploadVenueNightPhotoParams(venueId: venueId, filePath: filePath),
    );
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        uploadVenueNightPhotoUseCaseProvider.overrideWithValue(
          mockUploadUseCase,
        ),
      ],
    );
  }

  group('AddPhotoNotifier', () {
    test('starts idle', () {
      final container = createContainer();
      expect(
        container.read(addPhotoNotifierProvider(venueId)),
        isA<AddPhotoIdle>(),
      );
    });

    test('upload() goes uploading then success, using the given venueId',
        () async {
      when(() => mockUploadUseCase(any()))
          .thenAnswer((_) async => const Right(uploaded));

      final container = createContainer();
      final future = container
          .read(addPhotoNotifierProvider(venueId).notifier)
          .upload(filePath);

      expect(
        container.read(addPhotoNotifierProvider(venueId)),
        isA<AddPhotoUploading>(),
      );
      await future;

      expect(
        container.read(addPhotoNotifierProvider(venueId)),
        isA<AddPhotoSuccess>(),
      );
      verify(
        () => mockUploadUseCase(
          const UploadVenueNightPhotoParams(
            venueId: venueId,
            filePath: filePath,
          ),
        ),
      ).called(1);
    });

    test('upload() surfaces the failure message on error', () async {
      when(() => mockUploadUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final container = createContainer();
      await container
          .read(addPhotoNotifierProvider(venueId).notifier)
          .upload(filePath);

      final state = container.read(addPhotoNotifierProvider(venueId));
      expect(state, isA<AddPhotoError>());
      expect((state as AddPhotoError).message, 'Erreur serveur');
    });

    test('reset() returns to idle', () async {
      when(() => mockUploadUseCase(any()))
          .thenAnswer((_) async => const Right(uploaded));

      final container = createContainer();
      await container
          .read(addPhotoNotifierProvider(venueId).notifier)
          .upload(filePath);
      container.read(addPhotoNotifierProvider(venueId).notifier).reset();

      expect(
        container.read(addPhotoNotifierProvider(venueId)),
        isA<AddPhotoIdle>(),
      );
    });
  });
}
