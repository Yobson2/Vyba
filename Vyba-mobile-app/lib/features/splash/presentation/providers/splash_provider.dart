import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/core/utils/logger.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

/// Result of splash initialization.
enum SplashResult {
  /// First launch — show onboarding.
  onboarding,

  /// Authenticated — go to home.
  authenticated,

  /// Not authenticated — go to login.
  unauthenticated,
}

/// Runs initialization checks: first launch, cached auth.
///
/// This provider is a pure reader — it never modifies other providers.
/// Auth state hydration is handled by [SplashPage] after navigation.
@riverpod
Future<SplashResult> splashInit(Ref ref) async {
  // Run init checks and a minimum 3-second delay in parallel so the
  // splash is always visible for at least 3 seconds.
  final (result, _) = await (
    _resolve(ref),
    Future<void>.delayed(const Duration(seconds: 3)),
  ).wait;

  return result;
}

Future<SplashResult> _resolve(Ref ref) async {
  try {
    final localStorage = ref.read(localStorageProvider);

    // Check first launch
    if (localStorage.isFirstLaunch) {
      return SplashResult.onboarding;
    }

    // Check for a cached user session directly (read-only).
    final result =
        await ref.read(getCachedUserUseCaseProvider).call(const NoParams());

    return result.fold(
      (_) => SplashResult.unauthenticated,
      (_) => SplashResult.authenticated,
    );
  } catch (e, st) {
    AppLogger.error(
      'Splash initialization failed',
      tag: 'SplashInit',
      error: e,
      stackTrace: st,
    );
    return SplashResult.unauthenticated;
  }
}
