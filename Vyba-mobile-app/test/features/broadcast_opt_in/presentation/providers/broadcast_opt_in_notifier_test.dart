import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_notifier.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_providers.dart';
import 'package:flutter_templates/features/broadcast_opt_in/presentation/providers/broadcast_opt_in_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockIsOptedInUseCase mockIsOptedInUseCase;
  late MockOptInUseCase mockOptInUseCase;
  late MockOptOutUseCase mockOptOutUseCase;

  const venueId = 'venue-1';

  setUp(() {
    mockIsOptedInUseCase = MockIsOptedInUseCase();
    mockOptInUseCase = MockOptInUseCase();
    mockOptOutUseCase = MockOptOutUseCase();
  });

  setUpAll(() {
    registerFallbackValue(venueId);
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        isOptedInUseCaseProvider.overrideWithValue(mockIsOptedInUseCase),
        optInUseCaseProvider.overrideWithValue(mockOptInUseCase),
        optOutUseCaseProvider.overrideWithValue(mockOptOutUseCase),
      ],
    );
  }

  group('BroadcastOptInNotifier', () {
    test('starts as optedOut when the backend says so', () async {
      when(() => mockIsOptedInUseCase(any()))
          .thenAnswer((_) async => const Right(false));

      final container = createContainer();
      container.listen(broadcastOptInNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      expect(
        container.read(broadcastOptInNotifierProvider(venueId)),
        isA<BroadcastOptedOut>(),
      );
    });

    test('starts as optedIn when the backend says so', () async {
      when(() => mockIsOptedInUseCase(any()))
          .thenAnswer((_) async => const Right(true));

      final container = createContainer();
      container.listen(broadcastOptInNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      expect(
        container.read(broadcastOptInNotifierProvider(venueId)),
        isA<BroadcastOptedIn>(),
      );
    });

    test('toggle() from optedOut optimistically opts in, then confirms',
        () async {
      when(() => mockIsOptedInUseCase(any()))
          .thenAnswer((_) async => const Right(false));
      when(() => mockOptInUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(broadcastOptInNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      final future = container
          .read(broadcastOptInNotifierProvider(venueId).notifier)
          .toggle();
      expect(
        container.read(broadcastOptInNotifierProvider(venueId)),
        isA<BroadcastOptedIn>(),
      );
      await future;

      expect(
        container.read(broadcastOptInNotifierProvider(venueId)),
        isA<BroadcastOptedIn>(),
      );
      verify(() => mockOptInUseCase(venueId)).called(1);
    });

    test('toggle() rolls back to optedOut when the opt-in call fails',
        () async {
      when(() => mockIsOptedInUseCase(any()))
          .thenAnswer((_) async => const Right(false));
      when(() => mockOptInUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final container = createContainer();
      container.listen(broadcastOptInNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container
          .read(broadcastOptInNotifierProvider(venueId).notifier)
          .toggle();

      expect(
        container.read(broadcastOptInNotifierProvider(venueId)),
        isA<BroadcastOptedOut>(),
      );
    });

    test('toggle() from optedIn optimistically opts out, then confirms',
        () async {
      when(() => mockIsOptedInUseCase(any()))
          .thenAnswer((_) async => const Right(true));
      when(() => mockOptOutUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(broadcastOptInNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container
          .read(broadcastOptInNotifierProvider(venueId).notifier)
          .toggle();

      expect(
        container.read(broadcastOptInNotifierProvider(venueId)),
        isA<BroadcastOptedOut>(),
      );
      verify(() => mockOptOutUseCase(venueId)).called(1);
    });
  });
}
