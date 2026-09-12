import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';

/// A plain factory (not freezed) — mirrors `FollowedVenueModel`'s reasoning:
/// a small, flat shape mapped straight from the backend JSON.
class NotificationPreferencesModel {
  const NotificationPreferencesModel._();

  static NotificationPreferences fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      weekendDigest: json['weekendDigest'] as bool? ?? true,
      goingReminder: json['goingReminder'] as bool? ?? true,
    );
  }
}
