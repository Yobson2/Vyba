import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/promotions/domain/entities/promo.dart';
import 'package:flutter_templates/features/promotions/domain/usecases/create_promo_usecase.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/create_promo_notifier.dart';
import 'package:flutter_templates/features/promotions/presentation/providers/promo_providers.dart';
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
  late MockCreatePromoUseCase mockCreatePromoUseCase;

  const tVenue = OwnerVenue(id: 'venue-1', name: 'Le Boony');
  const tNotLive = VenueTonight(
    isLive: false,
    liveSince: null,
    headline: null,
    djName: null,
    goingCount: 0,
  );
  final tPromo = Promo(
    id: 'promo-1',
    venueId: 'venue-1',
    title: 'Happy hour -50%',
    description: 'Jusqu’à 23h',
    publishedAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockGetMyVenueUseCase = MockGetMyVenueUseCase();
    mockGetTonightUseCase = MockGetTonightUseCase();
    mockCreatePromoUseCase = MockCreatePromoUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(
      const CreatePromoParams(venueId: '', title: '', description: ''),
    );
  });

  Future<ProviderContainer> createReadyContainer() async {
    final container = ProviderContainer(
      overrides: [
        getMyVenueUseCaseProvider.overrideWithValue(mockGetMyVenueUseCase),
        getTonightUseCaseProvider.overrideWithValue(mockGetTonightUseCase),
        createPromoUseCaseProvider.overrideWithValue(mockCreatePromoUseCase),
      ],
    );
    when(() => mockGetMyVenueUseCase(any()))
        .thenAnswer((_) async => const Right(tVenue));
    when(() => mockGetTonightUseCase(any()))
        .thenAnswer((_) async => const Right(tNotLive));
    // Warm up the owner venue so `venueNightNotifierProvider` is loaded
    // before `CreatePromoNotifier.submit()` reads it.
    container.listen(venueNightNotifierProvider, (_, __) {});
    await pumpEventQueue();
    return container;
  }

  group('CreatePromoNotifier', () {
    test('submit() publishes and records the last-published promo', () async {
      final container = await createReadyContainer();
      when(() => mockCreatePromoUseCase(any()))
          .thenAnswer((_) async => Right(tPromo));

      final success =
          await container.read(createPromoNotifierProvider.notifier).submit(
                title: 'Happy hour -50%',
                description: 'Jusqu’à 23h',
              );

      expect(success, isTrue);
      verify(
        () => mockCreatePromoUseCase(
          const CreatePromoParams(
            venueId: 'venue-1',
            title: 'Happy hour -50%',
            description: 'Jusqu’à 23h',
          ),
        ),
      ).called(1);

      final state = container.read(createPromoNotifierProvider);
      expect(state.submitting, isFalse);
      expect(state.lastPublished, tPromo);
    });

    test('submit() surfaces the failure message and keeps submitting false',
        () async {
      final container = await createReadyContainer();
      when(() => mockCreatePromoUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final success =
          await container.read(createPromoNotifierProvider.notifier).submit(
                title: 'x',
                description: 'y',
              );

      expect(success, isFalse);
      final state = container.read(createPromoNotifierProvider);
      expect(state.submitting, isFalse);
      expect(state.errorMessage, 'Erreur serveur');
      expect(state.lastPublished, isNull);
    });
  });
}
