import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/providers/push_notification_provider.dart';
import 'package:flutter_templates/core/utils/logger.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_registration_coordinator.g.dart';

/// Registers/deregisters the device's push token against the backend as the
/// user signs in/out (ticket 15) — the token itself comes from
/// `PushNotificationService`, never queried directly by callers.
@Riverpod(keepAlive: true)
NotificationRegistrationCoordinator notificationRegistrationCoordinator(
  Ref ref,
) {
  return NotificationRegistrationCoordinator(ref);
}

class NotificationRegistrationCoordinator {
  NotificationRegistrationCoordinator(this._ref);

  final Ref _ref;
  StreamSubscription<String>? _refreshSubscription;
  String? _lastKnownToken;

  /// Call once the user is authenticated (sign-in, or a restored session).
  Future<void> onAuthenticated() async {
    final pushService = _ref.read(pushNotificationServiceProvider);

    final token = await pushService.getToken();
    if (token != null) {
      await _register(token);
    }

    await _refreshSubscription?.cancel();
    _refreshSubscription = pushService.onTokenRefresh.listen(_register);
  }

  /// Call on sign-out — deregisters the last known token and stops
  /// listening for rotations until the next `onAuthenticated`.
  Future<void> onSignedOut() async {
    await _refreshSubscription?.cancel();
    _refreshSubscription = null;

    final token = _lastKnownToken;
    _lastKnownToken = null;
    if (token == null) return;

    final result =
        await _ref.read(deregisterDeviceTokenUseCaseProvider).call(token);
    result.fold(
      (Failure failure) => AppLogger.debug(
        'Device token deregistration failed: ${failure.message}',
        tag: 'Notifications',
      ),
      (_) {},
    );
    await _ref.read(pushNotificationServiceProvider).deleteToken();
  }

  Future<void> _register(String token) async {
    _lastKnownToken = token;
    final result =
        await _ref.read(registerDeviceTokenUseCaseProvider).call(token);
    result.fold(
      (Failure failure) => AppLogger.debug(
        'Device token registration failed: ${failure.message}',
        tag: 'Notifications',
      ),
      (_) {},
    );
  }
}
