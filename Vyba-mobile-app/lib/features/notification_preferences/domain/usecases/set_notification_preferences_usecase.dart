import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';
import 'package:flutter_templates/features/notification_preferences/domain/repositories/notification_preferences_repository.dart';

@immutable
class SetNotificationPreferencesParams {
  const SetNotificationPreferencesParams({
    this.weekendDigest,
    this.goingReminder,
  });

  final bool? weekendDigest;
  final bool? goingReminder;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetNotificationPreferencesParams &&
          runtimeType == other.runtimeType &&
          weekendDigest == other.weekendDigest &&
          goingReminder == other.goingReminder;

  @override
  int get hashCode => Object.hash(weekendDigest, goingReminder);
}

class SetNotificationPreferencesUseCase
    extends UseCase<NotificationPreferences, SetNotificationPreferencesParams> {
  const SetNotificationPreferencesUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  @override
  Future<Either<Failure, NotificationPreferences>> call(
    SetNotificationPreferencesParams params,
  ) {
    return _repository.setPreferences(
      weekendDigest: params.weekendDigest,
      goingReminder: params.goingReminder,
    );
  }
}
