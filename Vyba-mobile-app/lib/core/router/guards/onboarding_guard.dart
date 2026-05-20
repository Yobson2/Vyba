import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/providers/storage_providers.dart';
import 'package:flutter_templates/core/router/route_names.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Provides the redirect path based on onboarding completion.
///
/// Returns the onboarding path if the user has not completed onboarding
/// and is trying to access a post-onboarding route.
@riverpod
String? onboardingGuard(Ref ref, String currentPath) {
  final localStorage = ref.watch(localStorageProvider);
  final isOnboardingComplete = localStorage.isOnboardingComplete;

  if (!isOnboardingComplete && currentPath != RouteNames.onboarding) {
    return RouteNames.onboarding;
  }

  if (isOnboardingComplete && currentPath == RouteNames.onboarding) {
    return RouteNames.login;
  }

  return null;
}
