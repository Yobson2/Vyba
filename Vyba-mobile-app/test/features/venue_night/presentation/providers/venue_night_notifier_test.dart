import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/entities/owner_venue.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_headline_usecase.dart';
import 'package:flutter_templates/features/venue_night/domain/usecases/set_live_usecase.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_notifier.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_providers.dart';
import 'package:flutter_templates/features/venue_night/presentation/providers/venue_night_state.dart';
import 'package:flutter_templates/features/venues/domain/entities/venue_tonight.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockGetMyVenueUseCase mockGetMyVenueUseCase;
  late MockGetTonightUseCase mockGetTonightUseCase;
  late MockSetLiveUseCase mockSetLiveUseCase;
  late MockSetHeadlineUseCase mockSetHeadlineUseCase;

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
    mockSetLiveUseCase = MockSetLiveUseCase();
    mockSetHeadlineUseCase = MockSetHeadlineUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const SetLiveParams(venueId: '', isLive: false),
    );
    registerFallbackValue(const SetHeadlineParams(venueId: ''));
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        getMyVenueUseCaseProvider.overrideWithValue(mockGetMyVenueUseCase),
        getTonightUseCaseProvider.overrideWithValue(mockGetTonightUseCase),
        setLiveUseCaseProvider.overrideWithValue(mockSetLiveUseCase),
        setHeadlineUseCaseProvider.overrideWithValue(mockSetHeadlineUseCase),
      ],
    );
  }

  group('VenueNightNotifier', () {
    test('loads the owner venue and tonight state', () async {
      when(() => mockGetMyVenueUseCase(any()))
          .thenAnswer((_) async => const Right(tVenue));
      when(() => mockGetTonightUseCase(any()))
          .thenAnswer((_) async => const Right(tNotLive));

      final container = createContainer();
      // A listener keeps this autoDispose notifier alive across the async
      // _load() that build() kicks off.
      container.listen(venueNightNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final state = container.read(venueNightNotifierProvider);
      expect(state, isA<VenueNightLoaded>());
      expect((state as VenueNightLoaded).venue, tVenue);
      expect(state.tonight.isLive, isFalse);
    });

    test('surfaces an error when the owner has no bound venue', () async {
      when(() => mockGetMyVenueUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'No venue bound')),
      );

      final container = createContainer();
      container.listen(venueNightNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final state = container.read(venueNightNotifierProvider);
      expect(state, isA<VenueNightError>());
    });

    test('toggleLive calls SetLiveUseCase with the flipped state and updates',
        () async {
      when(() => mockGetMyVenueUseCase(any()))
          .thenAnswer((_) async => const Right(tVenue));
      when(() => mockGetTonightUseCase(any()))
          .thenAnswer((_) async => const Right(tNotLive));
      const tLive = VenueTonight(
        isLive: true,
        liveSince: null,
        headline: null,
        djName: null,
        goingCount: 0,
      );
      when(() => mockSetLiveUseCase(any()))
          .thenAnswer((_) async => const Right(tLive));

      final container = createContainer();
      container.listen(venueNightNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final error = await container
          .read(venueNightNotifierProvider.notifier)
          .toggleLive();

      expect(error, isNull);
      verify(
        () => mockSetLiveUseCase(
          const SetLiveParams(venueId: 'venue-1', isLive: true),
        ),
      ).called(1);
      final state =
          container.read(venueNightNotifierProvider) as VenueNightLoaded;
      expect(state.tonight.isLive, isTrue);
    });

    test('toggleLive keeps the loaded state and returns a message on failure',
        () async {
      when(() => mockGetMyVenueUseCase(any()))
          .thenAnswer((_) async => const Right(tVenue));
      when(() => mockGetTonightUseCase(any()))
          .thenAnswer((_) async => const Right(tNotLive));
      when(() => mockSetLiveUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final container = createContainer();
      container.listen(venueNightNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final error = await container
          .read(venueNightNotifierProvider.notifier)
          .toggleLive();

      expect(error, 'Erreur serveur');
      // State stays loaded (not blown away by the failed action).
      expect(
          container.read(venueNightNotifierProvider), isA<VenueNightLoaded>());
    });

    test('updateHeadline calls SetHeadlineUseCase and updates the headline',
        () async {
      when(() => mockGetMyVenueUseCase(any()))
          .thenAnswer((_) async => const Right(tVenue));
      when(() => mockGetTonightUseCase(any()))
          .thenAnswer((_) async => const Right(tNotLive));
      const tWithHeadline = VenueTonight(
        isLive: false,
        liveSince: null,
        headline: 'DJ Kobo ce soir',
        djName: 'DJ Kobo',
        goingCount: 0,
      );
      when(() => mockSetHeadlineUseCase(any()))
          .thenAnswer((_) async => const Right(tWithHeadline));

      final container = createContainer();
      container.listen(venueNightNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final error = await container
          .read(venueNightNotifierProvider.notifier)
          .updateHeadline(headline: 'DJ Kobo ce soir', djName: 'DJ Kobo');

      expect(error, isNull);
      final state =
          container.read(venueNightNotifierProvider) as VenueNightLoaded;
      expect(state.tonight.headline, 'DJ Kobo ce soir');
    });
  });
}
