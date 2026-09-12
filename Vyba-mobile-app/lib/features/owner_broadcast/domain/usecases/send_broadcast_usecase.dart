import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_templates/core/error/failures.dart';
import 'package:flutter_templates/core/usecase/usecase.dart';
import 'package:flutter_templates/features/owner_broadcast/domain/repositories/owner_broadcast_repository.dart';

@immutable
class SendBroadcastParams {
  const SendBroadcastParams({required this.venueId, required this.message});

  final String venueId;
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SendBroadcastParams &&
          runtimeType == other.runtimeType &&
          venueId == other.venueId &&
          message == other.message;

  @override
  int get hashCode => Object.hash(venueId, message);
}

class SendBroadcastUseCase extends UseCase<void, SendBroadcastParams> {
  const SendBroadcastUseCase(this._repository);

  final OwnerBroadcastRepository _repository;

  @override
  Future<Either<Failure, void>> call(SendBroadcastParams params) {
    return _repository.sendBroadcast(
      venueId: params.venueId,
      message: params.message,
    );
  }
}
