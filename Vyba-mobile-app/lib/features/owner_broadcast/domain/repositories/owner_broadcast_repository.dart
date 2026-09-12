import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';

abstract class OwnerBroadcastRepository {
  Future<Either<Failure, void>> sendBroadcast({
    required String venueId,
    required String message,
  });
}
