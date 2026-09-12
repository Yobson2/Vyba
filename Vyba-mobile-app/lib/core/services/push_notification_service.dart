import 'dart:async';
import 'dart:math';

import 'package:flutter_templates/core/utils/logger.dart';

/// Abstract push-token provider.
///
/// No real push project is configured for this environment yet (tracked
/// separately, out of scope for this ticket) — implement this with FCM
/// (`firebase_messaging`) once a Firebase project + `google-services.json`
/// exist. `NotificationCoordinator` only depends on this interface, so
/// swapping in the real implementation touches no registration/deep-link
/// logic.
///
/// Example with `firebase_messaging`:
/// ```dart
/// class FirebasePushNotificationService implements PushNotificationService {
///   @override
///   Future<String?> getToken() => FirebaseMessaging.instance.getToken();
///
///   @override
///   Stream<String> get onTokenRefresh =>
///       FirebaseMessaging.instance.onTokenRefresh;
///
///   @override
///   Future<void> deleteToken() => FirebaseMessaging.instance.deleteToken();
/// }
/// ```
abstract class PushNotificationService {
  /// The current token, or `null` if unavailable.
  Future<String?> getToken();

  /// Emits a new token whenever it rotates.
  Stream<String> get onTokenRefresh;

  /// Clears the local token (called on sign-out, alongside deregistration).
  Future<void> deleteToken();
}

/// Development stand-in: generates a stable per-session token so the
/// register/refresh/deregister flow is exercisable against the real backend
/// without a Firebase project. Never rotates on its own.
class DevPushNotificationService implements PushNotificationService {
  String? _token;
  final _refreshController = StreamController<String>.broadcast();

  @override
  Future<String?> getToken() async {
    _token ??= 'dev-token-${Random().nextInt(1 << 32)}';
    AppLogger.debug('Push token: $_token', tag: 'Notifications');
    return _token;
  }

  @override
  Stream<String> get onTokenRefresh => _refreshController.stream;

  @override
  Future<void> deleteToken() async {
    AppLogger.debug('Push token deleted: $_token', tag: 'Notifications');
    _token = null;
  }
}
