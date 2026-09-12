import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_templates/core/services/push_notification_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_notification_provider.g.dart';

/// The dev stand-in is wired here; a `FirebasePushNotificationService` slots
/// in behind the same interface once a real Firebase project exists (see
/// `PushNotificationService`'s doc comment) — no other code changes.
@Riverpod(keepAlive: true)
PushNotificationService pushNotificationService(Ref ref) {
  return DevPushNotificationService();
}
