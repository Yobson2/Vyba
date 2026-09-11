import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/going/domain/entities/going.dart';
import 'package:flutter_templates/features/going/domain/entities/owner_going_summary.dart';

abstract class GoingRepository {
  /// My current mark for [venueId] tonight, or `null` if I haven't marked.
  Future<Either<Failure, Going?>> getMine(String venueId);

  /// Offline tap → `NetworkFailure` with no call made (ADR-0002: fails, never queues).
  Future<Either<Failure, Going>> mark({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  });

  Future<Either<Failure, Going>> update({
    required String venueId,
    int? partySize,
    bool? identityPublic,
  });

  Future<Either<Failure, void>> cancel(String venueId);

  Future<Either<Failure, OwnerGoingSummary>> getOwnerSummary(String venueId);
}
