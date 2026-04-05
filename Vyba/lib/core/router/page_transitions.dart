import 'package:flutter/material.dart';
import 'package:flutter_templates/core/theme/app_motion.dart';
import 'package:go_router/go_router.dart';

/// Reusable page transitions for GoRouter routes.
///
/// Usage in a route definition:
/// ```dart
/// GoRoute(
///   path: '/example',
///   pageBuilder: (context, state) => AppPageTransitions.fade(
///     key: state.pageKey,
///     child: const ExamplePage(),
///   ),
/// )
/// ```
class AppPageTransitions {
  const AppPageTransitions._();

  static const _duration = AppMotion.pageTransition;

  /// Fade transition.
  static CustomTransitionPage<T> fade<T>({
    required Widget child,
    required LocalKey key,
    Duration duration = _duration,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide up from the bottom.
  static CustomTransitionPage<T> slideUp<T>({
    required Widget child,
    required LocalKey key,
    Duration duration = _duration,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Slide in from the right.
  static CustomTransitionPage<T> slideRight<T>({
    required Widget child,
    required LocalKey key,
    Duration duration = _duration,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  /// Scale + fade transition (zoom in).
  static CustomTransitionPage<T> scale<T>({
    required Widget child,
    required LocalKey key,
    Duration duration = _duration,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween<double>(begin: 0.9, end: 1)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
    );
  }
}
