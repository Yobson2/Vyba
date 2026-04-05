import 'package:flutter/material.dart';
import 'package:flutter_templates/core/widgets/loading/app_progress.dart';
import 'package:flutter_templates/core/widgets/states/app_error_state.dart';

/// State for paginated data.
class PaginatedState<T> {
  /// Creates a [PaginatedState].
  const PaginatedState({
    this.items = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoading = false,
    this.error,
  });

  /// Currently loaded items.
  final List<T> items;

  /// Current page number.
  final int page;

  /// Whether more pages are available.
  final bool hasMore;

  /// Whether a page is currently loading.
  final bool isLoading;

  /// Error message from the last load attempt.
  final String? error;

  /// Whether this is the initial empty state.
  bool get isEmpty => items.isEmpty && !isLoading && error == null;

  /// Creates a copy with the given fields replaced.
  PaginatedState<T> copyWith({
    List<T>? items,
    int? page,
    bool? hasMore,
    bool? isLoading,
    String? error,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Returns a fresh initial state (useful for pull-to-refresh).
  PaginatedState<T> reset() => const PaginatedState();
}

/// Scroll listener that triggers [onLoadMore] when nearing the end.
///
/// Attach to a [ScrollController] or use with [NotificationListener].
class PaginationScrollListener extends StatelessWidget {
  /// Creates a [PaginationScrollListener].
  const PaginationScrollListener({
    required this.child,
    required this.onLoadMore,
    required this.hasMore,
    required this.isLoading,
    super.key,
    this.threshold = 200,
    this.error,
    this.onRetry,
  });

  /// Scrollable child widget.
  final Widget child;

  /// Called when the user scrolls near the end.
  final VoidCallback onLoadMore;

  /// Whether more data is available.
  final bool hasMore;

  /// Whether data is currently loading.
  final bool isLoading;

  /// Pixel threshold from the end to trigger loading.
  final double threshold;

  /// Error message to show at the end.
  final String? error;

  /// Retry callback for error state.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - threshold &&
            hasMore &&
            !isLoading &&
            error == null) {
          onLoadMore();
        }
        return false;
      },
      child: Column(
        children: [
          Expanded(child: child),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: AppProgress(),
            ),
          if (error != null)
            AppErrorState(
              message: error!,
              onRetry: onRetry,
            ),
        ],
      ),
    );
  }
}
