import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/enums/user_role.dart';
import 'package:flutter_templates/core/providers/analytics_provider.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/router/analytics_observer.dart';
import 'package:flutter_templates/core/router/page_transitions.dart';
import 'package:flutter_templates/core/router/route_names.dart';
import 'package:flutter_templates/core/theme/app_colors.dart';
import 'package:flutter_templates/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_templates/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_notifier.dart';
import 'package:flutter_templates/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_templates/features/feed/presentation/pages/feed_page.dart';
import 'package:flutter_templates/features/follow/presentation/pages/followed_venues_page.dart';
import 'package:flutter_templates/features/home/presentation/pages/client_shell.dart';
import 'package:flutter_templates/features/home/presentation/pages/owner_shell.dart';
import 'package:flutter_templates/features/home/presentation/pages/profile_page.dart';
import 'package:flutter_templates/features/home/presentation/pages/settings_page.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/pages/notification_preferences_page.dart';
import 'package:flutter_templates/features/notifications/presentation/pages/notifications_page.dart';
import 'package:flutter_templates/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter_templates/features/owner_dashboard/presentation/pages/owner_dashboard_page.dart';
import 'package:flutter_templates/features/promotions/presentation/pages/create_promotion_page.dart';
import 'package:flutter_templates/features/role_selection/presentation/pages/role_selection_page.dart';
import 'package:flutter_templates/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter_templates/features/venues/presentation/pages/explore_page.dart';
import 'package:flutter_templates/features/venues/presentation/pages/venue_detail_page.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _clientExploreKey = GlobalKey<NavigatorState>();
final _clientFeedKey = GlobalKey<NavigatorState>();
final _clientProfileKey = GlobalKey<NavigatorState>();
final _ownerDashboardKey = GlobalKey<NavigatorState>();
final _ownerPromosKey = GlobalKey<NavigatorState>();
final _ownerProfileKey = GlobalKey<NavigatorState>();

/// Public routes that don't require authentication.
const _publicPaths = [
  RouteNames.splash,
  RouteNames.onboarding,
  RouteNames.roleSelection,
  RouteNames.login,
  RouteNames.otpVerification,
];

/// Provides the application [GoRouter] instance.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authState = ValueNotifier<AuthState>(const AuthInitial());

  ref
    ..listen(authNotifierProvider, (_, next) {
      authState.value = next;
    })
    ..onDispose(authState.dispose);

  final analytics = ref.read(analyticsServiceProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    refreshListenable: authState,
    observers: [AnalyticsObserver(analytics)],
    redirect: (context, state) {
      final currentPath = state.matchedLocation;
      final auth = authState.value;

      // Never redirect away from splash.
      if (currentPath == RouteNames.splash) return null;

      // Don't redirect while auth state is still initializing.
      if (auth is AuthInitial || auth is AuthLoading) return null;

      final isPublicRoute = _publicPaths.contains(currentPath);

      // Redirect authenticated users away from auth pages.
      if (auth is AuthAuthenticated && isPublicRoute) {
        // Route based on user role.
        final role = auth.user.role;
        if (role == UserRole.venueOwner) {
          return RouteNames.ownerDashboard;
        }
        return RouteNames.explore;
      }

      // Redirect unauthenticated users to login for protected routes.
      if (auth is AuthUnauthenticated && !isPublicRoute) {
        return RouteNames.login;
      }

      // Check onboarding completion for the login route.
      if (auth is AuthUnauthenticated && currentPath == RouteNames.login) {
        final localStorage = ref.read(localStorageProvider);
        if (!localStorage.isOnboardingComplete && localStorage.isFirstLaunch) {
          return RouteNames.onboarding;
        }
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
    routes: [
      // Splash
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splashName,
        builder: (context, state) => const SplashPage(),
      ),

      // Onboarding
      GoRoute(
        path: RouteNames.onboarding,
        name: RouteNames.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),

      // Role Selection
      GoRoute(
        path: RouteNames.roleSelection,
        name: RouteNames.roleSelectionName,
        builder: (context, state) => const RoleSelectionPage(),
      ),

      // Auth routes (phone-OTP only)
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.loginName,
        pageBuilder: (context, state) => AppPageTransitions.fade(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.otpVerification,
        name: RouteNames.otpVerificationName,
        builder: (context, state) {
          final extra = state.extra;
          final (phoneNumber, isFirstSignIn) =
              extra is ({String phoneNumber, bool isFirstSignIn})
                  ? (extra.phoneNumber, extra.isFirstSignIn)
                  : ('', false);
          return OtpVerificationPage(
            phoneNumber: phoneNumber,
            isFirstSignIn: isFirstSignIn,
          );
        },
      ),

      // ════════════════════════════════════════════════════════════
      // CLIENT SHELL (3 tabs: Explore, Feed, Profile)
      // ════════════════════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ClientShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Explore
          StatefulShellBranch(
            navigatorKey: _clientExploreKey,
            routes: [
              GoRoute(
                path: RouteNames.explore,
                name: RouteNames.exploreName,
                builder: (context, state) => const ExplorePage(),
                routes: [
                  // Venue Detail
                  GoRoute(
                    path: RouteNames.venueDetail,
                    name: RouteNames.venueDetailName,
                    builder: (context, state) {
                      final venueId = state.pathParameters['venueId']!;
                      return VenueDetailPage(venueId: venueId);
                    },
                  ),
                  // Follows ("mes lieux suivis")
                  GoRoute(
                    path: RouteNames.follows,
                    name: RouteNames.followsName,
                    builder: (context, state) => const FollowedVenuesPage(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: Feed
          StatefulShellBranch(
            navigatorKey: _clientFeedKey,
            routes: [
              GoRoute(
                path: RouteNames.feed,
                name: RouteNames.feedName,
                builder: (context, state) => const FeedPage(),
              ),
            ],
          ),
          // Branch 2: Profile
          StatefulShellBranch(
            navigatorKey: _clientProfileKey,
            routes: [
              GoRoute(
                path: RouteNames.clientProfile,
                name: RouteNames.clientProfileName,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: RouteNames.settings,
                    name: '${RouteNames.settingsName}Client',
                    builder: (context, state) => const SettingsPage(),
                    routes: [
                      GoRoute(
                        path: RouteNames.notificationPreferences,
                        name: RouteNames.notificationPreferencesName,
                        builder: (context, state) =>
                            const NotificationPreferencesPage(),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: RouteNames.notifications,
                    name: RouteNames.notificationsName,
                    builder: (context, state) => const NotificationsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      // ════════════════════════════════════════════════════════════
      // OWNER SHELL (3 tabs: Dashboard, Promos, Profile)
      // ════════════════════════════════════════════════════════════
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            OwnerShell(navigationShell: navigationShell),
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            navigatorKey: _ownerDashboardKey,
            routes: [
              GoRoute(
                path: RouteNames.ownerDashboard,
                name: RouteNames.ownerDashboardName,
                builder: (context, state) => const OwnerDashboardPage(),
              ),
            ],
          ),
          // Branch 1: Promos
          StatefulShellBranch(
            navigatorKey: _ownerPromosKey,
            routes: [
              GoRoute(
                path: RouteNames.ownerPromos,
                name: RouteNames.ownerPromosName,
                builder: (context, state) {
                  return const Scaffold(
                    backgroundColor: AppColors.background,
                    body: Center(child: Text('My Promotions')),
                  );
                },
                routes: [
                  GoRoute(
                    path: RouteNames.createPromotion,
                    name: RouteNames.createPromotionName,
                    builder: (context, state) => const CreatePromotionPage(),
                  ),
                ],
              ),
            ],
          ),
          // Branch 2: Owner Profile
          StatefulShellBranch(
            navigatorKey: _ownerProfileKey,
            routes: [
              GoRoute(
                path: RouteNames.ownerProfile,
                name: RouteNames.ownerProfileName,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: RouteNames.settings,
                    name: '${RouteNames.settingsName}Owner',
                    builder: (context, state) => const SettingsPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
