import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_templates/core/config/env_provider.dart';
import 'package:flutter_templates/core/router/app_router.dart';
import 'package:flutter_templates/core/theme/app_theme.dart';
import 'package:flutter_templates/core/theme/theme_provider.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_registration_coordinator.dart';
import 'package:flutter_templates/l10n/app_localizations.dart';

/// Root application widget.
///
/// Configures [MaterialApp.router] with GoRouter, theme, and localization.
class App extends ConsumerWidget {
  /// Creates an [App].
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    final env = ref.watch(envProvider);

    // Push-token register/deregister follows sign-in/out (ticket 15) —
    // wired once at the app root so it fires regardless of entry path
    // (OTP verify, or a restored session on launch).
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      final coordinator = ref.read(notificationRegistrationCoordinatorProvider);
      if (next is AuthAuthenticated) {
        unawaited(coordinator.onAuthenticated());
      } else if (next is AuthUnauthenticated && previous is AuthAuthenticated) {
        unawaited(coordinator.onSignedOut());
      }
    });

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        title: 'Vyba',
        debugShowCheckedModeBanner: env.showDebugBanner,

        // Theme
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        // Router
        routerConfig: router,
        // Localization
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
