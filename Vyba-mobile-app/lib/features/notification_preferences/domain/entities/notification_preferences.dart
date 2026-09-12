import 'package:flutter/foundation.dart';

@immutable
class NotificationPreferences {
  const NotificationPreferences({
    required this.weekendDigest,
    required this.goingReminder,
  });

  final bool weekendDigest;
  final bool goingReminder;

  NotificationPreferences copyWith({
    bool? weekendDigest,
    bool? goingReminder,
  }) {
    return NotificationPreferences(
      weekendDigest: weekendDigest ?? this.weekendDigest,
      goingReminder: goingReminder ?? this.goingReminder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferences &&
          runtimeType == other.runtimeType &&
          weekendDigest == other.weekendDigest &&
          goingReminder == other.goingReminder;

  @override
  int get hashCode => Object.hash(weekendDigest, goingReminder);
}
