import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';
import 'package:flutter_templates/features/feed/domain/entities/feed_result.dart';
import 'package:flutter_templates/features/feed/domain/usecases/get_feed_usecase.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_notifier.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_providers.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_providers.dart';

void main() {
  late MockGetFeedUseCase mockGetFeedUseCase;

  final tLive = LiveTonightFeedItem(
    id: 'live-1',
    venueId: 'venue-1',
    venueName: 'Le Boony',
    startsAt: DateTime.utc(2026, 1, 1),
    expiresAt: DateTime.utc(2026, 1, 2),
    publishedAt: DateTime.utc(2026, 1, 1, 22),
  );
  final tEditorial = EditorialFeedItem(
    id: 'editorial-1',
    venueId: null,
    venueName: null,
    startsAt: null,
    expiresAt: DateTime.utc(2026, 2, 1),
    publishedAt: DateTime.utc(2026, 1, 1, 18),
    title: 'Ce soir à Zone 4',
    body: '5 spots chauds ce soir.',
  );

  setUp(() {
    mockGetFeedUseCase = MockGetFeedUseCase();
  });

  setUpAll(() {
    registerFallbackValue(const GetFeedParams(page: 1));
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [getFeedUseCaseProvider.overrideWithValue(mockGetFeedUseCase)],
    );
  }

  group('FeedNotifier', () {
    test('renders the server order verbatim', () async {
      when(() => mockGetFeedUseCase(any())).thenAnswer(
        (_) async => Right(
          FeedResult(
              items: [tLive, tEditorial], isFromCache: false, hasMore: false),
        ),
      );

      final container = createContainer();
      container.listen(feedNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final state = container.read(feedNotifierProvider) as FeedLoaded;
      expect(state.items, [tLive, tEditorial]);
      expect(state.isFromCache, isFalse);
    });

    test('an empty payload yields an empty loaded state', () async {
      when(() => mockGetFeedUseCase(any())).thenAnswer(
        (_) async => const Right(
            FeedResult(items: [], isFromCache: false, hasMore: false)),
      );

      final container = createContainer();
      container.listen(feedNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final state = container.read(feedNotifierProvider) as FeedLoaded;
      expect(state.items, isEmpty);
    });

    test(
        'a network error with a warm cache yields the cached list + offline flag',
        () async {
      when(() => mockGetFeedUseCase(any())).thenAnswer(
        (_) async => Right(
          FeedResult(items: [tEditorial], isFromCache: true, hasMore: false),
        ),
      );

      final container = createContainer();
      container.listen(feedNotifierProvider, (_, __) {});
      await pumpEventQueue();

      final state = container.read(feedNotifierProvider) as FeedLoaded;
      expect(state.isFromCache, isTrue);
      expect(state.items, [tEditorial]);
    });

    test('a genuine failure with no cache surfaces an error state', () async {
      when(() => mockGetFeedUseCase(any())).thenAnswer(
        (_) async => const Left(NetworkFailure()),
      );

      final container = createContainer();
      container.listen(feedNotifierProvider, (_, __) {});
      await pumpEventQueue();

      expect(container.read(feedNotifierProvider), isA<FeedError>());
    });

    test('refresh() re-fetches page 1', () async {
      when(() => mockGetFeedUseCase(any())).thenAnswer(
        (_) async => Right(
          FeedResult(items: [tLive], isFromCache: false, hasMore: false),
        ),
      );

      final container = createContainer();
      container.listen(feedNotifierProvider, (_, __) {});
      await pumpEventQueue();

      await container.read(feedNotifierProvider.notifier).refresh();

      verify(
        () => mockGetFeedUseCase(const GetFeedParams(page: 1, limit: 20)),
      ).called(2); // initial build() load + refresh()
    });

    test('loadMore appends the next page and stops when hasMore is false',
        () async {
      when(() => mockGetFeedUseCase(const GetFeedParams(page: 1, limit: 20)))
          .thenAnswer(
        (_) async => Right(
          FeedResult(items: [tLive], isFromCache: false, hasMore: true),
        ),
      );
      when(() => mockGetFeedUseCase(const GetFeedParams(page: 2, limit: 20)))
          .thenAnswer(
        (_) async => Right(
          FeedResult(items: [tEditorial], isFromCache: false, hasMore: false),
        ),
      );

      final container = createContainer();
      container.listen(feedNotifierProvider, (_, __) {});
      await pumpEventQueue();

      await container.read(feedNotifierProvider.notifier).loadMore();

      final state = container.read(feedNotifierProvider) as FeedLoaded;
      expect(state.items, [tLive, tEditorial]);
      expect(state.hasMore, isFalse);

      // Further loadMore calls are no-ops once hasMore is false.
      await container.read(feedNotifierProvider.notifier).loadMore();
      verifyNever(
          () => mockGetFeedUseCase(const GetFeedParams(page: 3, limit: 20)));
    });
  });
}
