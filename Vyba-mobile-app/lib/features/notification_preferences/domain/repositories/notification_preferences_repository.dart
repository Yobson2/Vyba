import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';

abstract class NotificationPreferencesRepository {
  Future<Either<Failure, NotificationPreferences>> getPreferences();

  Future<Either<Failure, NotificationPreferences>> setPreferences({
    bool? weekendDigest,
    bool? goingReminder,
  });

  Future<Either<Failure, void>> registerDeviceToken(String token);

  Future<Either<Failure, void>> deregisterDeviceToken(String token);
}
