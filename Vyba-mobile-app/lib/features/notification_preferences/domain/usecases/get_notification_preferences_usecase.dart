import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/entities/notification_preferences.dart';
import 'package:flutter_templates/features/notification_preferences/domain/repositories/notification_preferences_repository.dart';

class GetNotificationPreferencesUseCase
    extends UseCase<NotificationPreferences, NoParams> {
  const GetNotificationPreferencesUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  @override
  Future<Either<Failure, NotificationPreferences>> call(NoParams params) {
    return _repository.getPreferences();
  }
}
