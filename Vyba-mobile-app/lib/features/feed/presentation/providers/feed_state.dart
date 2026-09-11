import 'package:flutter_templates/features/feed/domain/entities/feed_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feed_state.freezed.dart';

@freezed
sealed class FeedState with _$FeedState {
  const factory FeedState.loading() = FeedLoading;
  const factory FeedState.loaded({
    required List<FeedItem> items,
    required bool isFromCache,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = FeedLoaded;
  const factory FeedState.error({required String message}) = FeedError;
}
