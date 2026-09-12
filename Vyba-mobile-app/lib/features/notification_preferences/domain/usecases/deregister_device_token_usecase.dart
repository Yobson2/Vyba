import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/notification_preferences/domain/repositories/notification_preferences_repository.dart';

class DeregisterDeviceTokenUseCase extends UseCase<void, String> {
  const DeregisterDeviceTokenUseCase(this._repository);

  final NotificationPreferencesRepository _repository;

  @override
  Future<Either<Failure, void>> call(String token) {
    return _repository.deregisterDeviceToken(token);
  }
}
