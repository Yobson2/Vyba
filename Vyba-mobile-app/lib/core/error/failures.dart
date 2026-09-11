import 'package:flutter/foundation.dart';

/// Typed failure classes for functional error handling.
///
/// Used with `Either<Failure, T>` from dartz to represent
/// domain-level errors without throwing exceptions.
@immutable
sealed class Failure {
  /// Creates a [Failure] with an optional [message] and [statusCode].
  const Failure({this.message = '', this.statusCode});

  /// Human-readable error message.
  final String message;

  /// Optional HTTP status code associated with the failure.
  final int? statusCode;

  @override
  String toString() => '$runtimeType(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode;

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode);
}

/// Failure originating from a remote server error (5xx, unexpected response).
class ServerFailure extends Failure {
  /// Creates a [ServerFailure].
  const ServerFailure(
      {super.message = 'Server error occurred', super.statusCode});
}

/// Failure originating from local cache operations.
class CacheFailure extends Failure {
  /// Creates a [CacheFailure].
  const CacheFailure({super.message = 'Cache error occurred'});
}

/// Failure due to no network connectivity.
class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure due to unauthorized access (401/403).
class UnauthorizedFailure extends Failure {
  /// Creates an [UnauthorizedFailure].
  const UnauthorizedFailure({
    super.message = 'Unauthorized access',
    super.statusCode = 401,
  });
}

/// Failure due to input validation errors.
class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure] with field-level [errors].
  const ValidationFailure({
    super.message = 'Validation failed',
    this.errors = const {},
  });

  /// Map of field names to their validation error messages.
  final Map<String, List<String>> errors;
}
