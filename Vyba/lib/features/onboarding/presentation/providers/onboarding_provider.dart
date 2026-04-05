import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

/// Manages onboarding page state and completion.
@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  int build() => 0;

  /// Advances to the next page.
  void nextPage() {
    if (state < 2) state = state + 1;
  }

  /// Goes to the previous page.
  void previousPage() {
    if (state > 0) state = state - 1;
  }

  /// Sets the current page index.
  void setPage(int page) => state = page;

  /// Marks onboarding as complete in local storage.
  Future<void> complete() async {
    final localStorage = ref.read(localStorageProvider);
    await localStorage.setOnboardingComplete();
    await localStorage.setFirstLaunchDone();
  }
}
