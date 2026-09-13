import 'package:dartz/dartz.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/features/reservations/domain/entities/availability.dart';
import 'package:flutter_templates/features/reservations/domain/entities/reservation.dart';

abstract class ReservationRepository {
  /// My current active (pending/confirmed) request for [venueId] tonight, or `null`.
  Future<Either<Failure, Reservation?>> getMine(String venueId);

  /// Offline tap → `NetworkFailure` with no call made (same rule as "J'y vais", ADR-0002).
  Future<Either<Failure, Reservation>> create({
    required String venueId,
    int? partySize,
    String? note,
  });

  Future<Either<Failure, void>> cancel(String venueId);

  Future<Either<Failure, Availability>> getAvailability(String venueId);

  /// Owner-facing: tonight's requests, pending first.
  Future<Either<Failure, List<Reservation>>> listForOwner(String venueId);

  /// Owner confirms or rejects one request.
  Future<Either<Failure, Reservation>> respond({
    required String reservationId,
    required bool confirm,
  });
}
