import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_notifier.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_providers.dart';
import 'package:flutter_templates/features/follow/presentation/providers/follow_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockIsFollowingUseCase mockIsFollowingUseCase;
  late MockFollowVenueUseCase mockFollowVenueUseCase;
  late MockUnfollowVenueUseCase mockUnfollowVenueUseCase;

  const venueId = 'venue-1';

  setUp(() {
    mockIsFollowingUseCase = MockIsFollowingUseCase();
    mockFollowVenueUseCase = MockFollowVenueUseCase();
    mockUnfollowVenueUseCase = MockUnfollowVenueUseCase();
  });

  setUpAll(() {
    registerFallbackValue(venueId);
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        isFollowingUseCaseProvider.overrideWithValue(mockIsFollowingUseCase),
        followVenueUseCaseProvider.overrideWithValue(mockFollowVenueUseCase),
        unfollowVenueUseCaseProvider
            .overrideWithValue(mockUnfollowVenueUseCase),
      ],
    );
  }

  group('FollowNotifier', () {
    test('starts as notFollowing when the backend says so', () async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(false));

      final container = createContainer();
      container.listen(followNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowNotFollowing>(),
      );
    });

    test('starts as following when the backend says so', () async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(true));

      final container = createContainer();
      container.listen(followNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowFollowing>(),
      );
    });

    test('toggle() from notFollowing optimistically follows, then confirms',
        () async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(false));
      when(() => mockFollowVenueUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(followNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      final future =
          container.read(followNotifierProvider(venueId).notifier).toggle();
      // Optimistic: flips before the backend call resolves.
      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowFollowing>(),
      );
      await future;

      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowFollowing>(),
      );
      verify(() => mockFollowVenueUseCase(venueId)).called(1);
    });

    test('toggle() rolls back to notFollowing when the follow call fails',
        () async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(false));
      when(() => mockFollowVenueUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final container = createContainer();
      container.listen(followNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container
          .read(followNotifierProvider(venueId).notifier)
          .toggle();

      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowNotFollowing>(),
      );
    });

    test('toggle() from following optimistically unfollows, then confirms',
        () async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(true));
      when(() => mockUnfollowVenueUseCase(any()))
          .thenAnswer((_) async => const Right(null));

      final container = createContainer();
      container.listen(followNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container
          .read(followNotifierProvider(venueId).notifier)
          .toggle();

      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowNotFollowing>(),
      );
      verify(() => mockUnfollowVenueUseCase(venueId)).called(1);
    });

    test('toggle() rolls back to following when the unfollow call fails',
        () async {
      when(() => mockIsFollowingUseCase(any()))
          .thenAnswer((_) async => const Right(true));
      when(() => mockUnfollowVenueUseCase(any())).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Erreur serveur')),
      );

      final container = createContainer();
      container.listen(followNotifierProvider(venueId), (_, __) {});
      await pumpEventQueue();

      await container
          .read(followNotifierProvider(venueId).notifier)
          .toggle();

      expect(
        container.read(followNotifierProvider(venueId)),
        isA<FollowFollowing>(),
      );
    });
  });
}
