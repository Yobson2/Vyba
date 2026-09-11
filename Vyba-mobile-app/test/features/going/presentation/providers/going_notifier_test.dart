import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/domain/usecases/mark_going_usecase.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_notifier.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_providers.dart';
import 'package:flutter_templates/features/going/presentation/providers/going_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockGetMineUseCase mockGetMineUseCase;
  late MockMarkGoingUseCase mockMarkGoingUseCase;
  late MockUpdateGoingUseCase mockUpdateGoingUseCase;
  late MockCancelGoingUseCase mockCancelGoingUseCase;

  const venueId = 'venue-1';
  const tGoing = Going(
    id: 'going-1',
    venueId: venueId,
    partySize: 1,
    identityPublic: false,
  );

  setUp(() {
    mockGetMineUseCase = MockGetMineUseCase();
    mockMarkGoingUseCase = MockMarkGoingUseCase();
    mockUpdateGoingUseCase = MockUpdateGoingUseCase();
    mockCancelGoingUseCase = MockCancelGoingUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const GoingActionParams(venueId: venueId));
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        getMineUseCaseProvider.overrideWithValue(mockGetMineUseCase),
        markGoingUseCaseProvider.overrideWithValue(mockMarkGoingUseCase),
        updateGoingUseCaseProvider.overrideWithValue(mockUpdateGoingUseCase),
        cancelGoingUseCaseProvider.overrideWithValue(mockCancelGoingUseCase),
      ],
    );
  }

  group('GoingNotifier', () {
    test('starts as notMarked when there is no existing mark', () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      expect(container.read(goingNotifierProvider(venueId)), isA<GoingNotMarked>());
    });

    test('starts as marked when a mark already exists', () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(tGoing));

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      final state = container.read(goingNotifierProvider(venueId)) as GoingMarked;
      expect(state.going, tGoing);
    });

    test('mark() transitions to marked on success', () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(null));
      when(() => mockMarkGoingUseCase(any())).thenAnswer((_) async => const Right(tGoing));

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container.read(goingNotifierProvider(venueId).notifier).mark();

      final state = container.read(goingNotifierProvider(venueId)) as GoingMarked;
      expect(state.going, tGoing);
    });

    test('mark() while offline transitions to offline, without disguising it as a generic error',
        () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(null));
      when(() => mockMarkGoingUseCase(any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container.read(goingNotifierProvider(venueId).notifier).mark();

      expect(container.read(goingNotifierProvider(venueId)), isA<GoingOffline>());
    });

    test('mark() on an owned venue transitions to ownedVenue', () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(null));
      when(() => mockMarkGoingUseCase(any())).thenAnswer(
        (_) async => const Left(
          UnauthorizedFailure(message: "Can't mark your own venue", code: 'GOING_002'),
        ),
      );

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container.read(goingNotifierProvider(venueId).notifier).mark();

      expect(container.read(goingNotifierProvider(venueId)), isA<GoingOwnedVenue>());
    });

    test('cancel() returns to notMarked', () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(tGoing));
      when(() => mockCancelGoingUseCase(any())).thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container.read(goingNotifierProvider(venueId).notifier).cancel();

      expect(container.read(goingNotifierProvider(venueId)), isA<GoingNotMarked>());
    });

    test('update() only acts when currently marked', () async {
      when(() => mockGetMineUseCase(any())).thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(goingNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container.read(goingNotifierProvider(venueId).notifier).update(partySize: 3);

      verifyNever(() => mockUpdateGoingUseCase(any()));
      expect(container.read(goingNotifierProvider(venueId)), isA<GoingNotMarked>());
    });
  });
}
