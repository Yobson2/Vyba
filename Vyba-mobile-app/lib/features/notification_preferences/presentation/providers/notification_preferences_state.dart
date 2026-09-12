import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences_state.freezed.dart';

/// The notification-preferences screen's load/toggle state (ticket 15).
@freezed
sealed class NotificationPreferencesState with _$NotificationPreferencesState {
  const factory NotificationPreferencesState.loading() =
      NotificationPreferencesLoading;
  const factory NotificationPreferencesState.loaded(
    NotificationPreferences preferences,
  ) = NotificationPreferencesLoaded;
  const factory NotificationPreferencesState.error(String message) =
      NotificationPreferencesError;
}
