import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/owner_broadcast/domain/usecases/send_broadcast_usecase.dart';
import 'package:flutter_templates/features/owner_broadcast/presentation/providers/owner_broadcast_notifier.dart';
import 'package:flutter_templates/features/owner_broadcast/presentation/providers/owner_broadcast_providers.dart';
import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_notifier.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_providers.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockGetMyVenueUseCase mockGetMyVenueUseCase;
  late MockGetTonightUseCase mockGetTonightUseCase;
  late MockSendBroadcastUseCase mockSendBroadcastUseCase;

  const tVenue = OwnerVenue(id: 'venue-1', name: 'Le Boony');
  const tNotLive = VenueTonight(
    isLive: false,
    liveSince: null,
    headline: null,
    djName: null,
    goingCount: 0,
  );

  setUp(() {
    mockGetMyVenueUseCase = MockGetMyVenueUseCase();
    mockGetTonightUseCase = MockGetTonightUseCase();
    mockSendBroadcastUseCase = MockSendBroadcastUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const SendBroadcastParams(venueId: '', message: ''),
    );
  });

  Future<ProviderContainer> createReadyContainer() async {
    final container = ProviderContainer(
      overrides: [
        getMyVenueUseCaseProvider.overrideWithValue(mockGetMyVenueUseCase),
        getTonightUseCaseProvider.overrideWithValue(mockGetTonightUseCase),
        sendBroadcastUseCaseProvider
            .overrideWithValue(mockSendBroadcastUseCase),
      ],
    );
    when(() => mockGetMyVenueUseCase(any()))
        .thenAnswer((_) async => const Right(tVenue));
    when(() => mockGetTonightUseCase(any()))
        .thenAnswer((_) async => const Right(tNotLive));
    // Warm up the owner venue so `venueNightNotifierProvider` is loaded
    // before `OwnerBroadcastNotifier.send()` reads it.
    container.listen(venueNightNotifierProvider, (_, __) {});
    await pumpEventQueue();
    return container;
  }

  group('OwnerBroadcastNotifier', () {
    test('send() marks sent on success', () async {
      final container = await createReadyContainer();
      when(() => mockSendBroadcastUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      await container
          .read(ownerBroadcastNotifierProvider.notifier)
          .send('Happy hour prolongée !');

      verify(
        () => mockSendBroadcastUseCase(
          const SendBroadcastParams(
            venueId: 'venue-1',
            message: 'Happy hour prolongée !',
          ),
        ),
      ).called(1);
      final state = container.read(ownerBroadcastNotifierProvider);
      expect(state.sent, isTrue);
      expect(state.submitting, isFalse);
      expect(state.alreadySentTonight, isFalse);
    });

    test('send() sets alreadySentTonight on a 409, not a generic error',
        () async {
      final container = await createReadyContainer();
      when(() => mockSendBroadcastUseCase(any())).thenAnswer(
        (_) async => const Left(
          ServerFailure(message: 'Conflict', statusCode: 409),
        ),
      );

      await container
          .read(ownerBroadcastNotifierProvider.notifier)
          .send('Une deuxième fois ?');

      final state = container.read(ownerBroadcastNotifierProvider);
      expect(state.alreadySentTonight, isTrue);
      expect(state.sent, isFalse);
      expect(state.errorMessage, isNull);
    });

    test('send() surfaces a generic error message for a non-409 failure',
        () async {
      final container = await createReadyContainer();
      when(() => mockSendBroadcastUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      await container.read(ownerBroadcastNotifierProvider.notifier).send('x');

      final state = container.read(ownerBroadcastNotifierProvider);
      expect(state.errorMessage, 'Erreur serveur');
      expect(state.alreadySentTonight, isFalse);
      expect(state.sent, isFalse);
    });
  });
}
