import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/usecases/set_notification_preferences_usecase.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_providers.dart';
import 'package:flutter_templates/features/notification_preferences/presentation/providers/notification_preferences_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_preferences_notifier.g.dart';

/// Backs the "Préférences de notification" settings screen — optimistic
/// toggles with rollback on failure, mirroring `FollowNotifier` (ticket 10).
@riverpod
class NotificationPreferencesNotifier
    extends _$NotificationPreferencesNotifier {
  @override
  NotificationPreferencesState build() {
    _load();
    return const NotificationPreferencesState.loading();
  }

  Future<void> _load() async {
    final result = await ref
        .read(getNotificationPreferencesUseCaseProvider)
        .call(const NoParams());
    state = result.fold(
      (failure) => NotificationPreferencesState.error(failure.message),
      NotificationPreferencesState.loaded,
    );
  }

  // Positional `bool` matches `SwitchListTile.onChanged`'s `ValueChanged<bool>`
  // shape directly, so the widget can tear these off instead of wrapping
  // them in a closure.
  // ignore: avoid_positional_boolean_parameters
  Future<void> setWeekendDigest(bool value) => _toggle(weekendDigest: value);

  // ignore: avoid_positional_boolean_parameters
  Future<void> setGoingReminder(bool value) => _toggle(goingReminder: value);

  Future<void> _toggle({bool? weekendDigest, bool? goingReminder}) async {
    final current = state;
    if (current is! NotificationPreferencesLoaded) return;

    final optimistic = current.preferences.copyWith(
      weekendDigest: weekendDigest,
      goingReminder: goingReminder,
    );
    state = NotificationPreferencesState.loaded(optimistic);

    final result =
        await ref.read(setNotificationPreferencesUseCaseProvider).call(
              SetNotificationPreferencesParams(
                weekendDigest: weekendDigest,
                goingReminder: goingReminder,
              ),
            );
    result.fold(
      // Rollback — the optimistic toggle didn't actually land.
      (failure) => state = NotificationPreferencesState.loaded(
        current.preferences,
      ),
      (confirmed) => state = NotificationPreferencesState.loaded(confirmed),
    );
  }
}
