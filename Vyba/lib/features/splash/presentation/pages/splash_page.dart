import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/theme/app_spacing.dart';
import 'package:flutter_templates/core/widgets/loading/app_progress.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/splash/presentation/providers/splash_provider.dart';
import 'package:go_router/go_router.dart';

/// Splash page shown at app launch.
///
/// Runs init checks and navigates to the appropriate screen.
class SplashPage extends ConsumerWidget {
  /// Creates a [SplashPage].
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashInitProvider, (_, next) {
      if (!context.mounted) return;
      switch (next) {
        case AsyncData(:final value):
          switch (value) {
            case SplashResult.onboarding:
              context.go('/onboarding');
            case SplashResult.authenticated:
              // Hydrate auth state first so the router redirect knows the
              // user's role, then navigate to a public route — the redirect
              // will send them to /explore or /owner/dashboard.
              ref
                  .read(authNotifierProvider.notifier)
                  .checkAuthStatus()
                  .then((_) {
                if (context.mounted) context.go('/login');
              });
            case SplashResult.unauthenticated:
              ref.read(authNotifierProvider.notifier).checkAuthStatus();
              context.go('/login');
          }
        case AsyncError():
          context.go('/login');
        case _:
          break;
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icon/icon.png',
              width: 100,
              height: 100,
            ),
            AppSpacing.verticalXl,
            const AppProgress(),
          ],
        ),
      ),
    );
  }
}
