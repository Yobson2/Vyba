import 'package:flutter_templates/features/feed/domain/usecases/get_feed_usecase.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_providers.dart';
import 'package:flutter_templates/features/feed/presentation/providers/feed_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feed_notifier.g.dart';

const _pageSize = 20;

/// Renders the server's feed order verbatim (no client re-sorting — ADR-0001).
@riverpod
class FeedNotifier extends _$FeedNotifier {
  int _page = 1;

  @override
  FeedState build() {
    _load();
    return const FeedState.loading();
  }

  Future<void> _load() async {
    _page = 1;
    final result = await ref.read(getFeedUseCaseProvider).call(
          const GetFeedParams(page: 1, limit: _pageSize),
        );
    state = result.fold(
      (failure) => FeedState.error(message: failure.message),
      (feed) => FeedState.loaded(
        items: feed.items,
        isFromCache: feed.isFromCache,
        hasMore: feed.hasMore,
      ),
    );
  }

  Future<void> refresh() => _load();

  Future<void> loadMore() async {
    final current = state;
    if (current is! FeedLoaded || current.isLoadingMore || !current.hasMore) {
      return;
    }

    state = current.copyWith(isLoadingMore: true);
    final nextPage = _page + 1;
    final result = await ref.read(getFeedUseCaseProvider).call(
          GetFeedParams(page: nextPage, limit: _pageSize),
        );
    state = result.fold(
      // Keep the existing list on a load-more failure — don't disrupt scroll.
      (_) => current.copyWith(isLoadingMore: false),
      (feed) {
        _page = nextPage;
        return FeedState.loaded(
          items: [...current.items, ...feed.items],
          isFromCache: current.isFromCache,
          hasMore: feed.hasMore,
        );
      },
    );
  }
}
