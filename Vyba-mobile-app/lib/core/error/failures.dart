import 'package:flutter/foundation.dart';

/// Typed failure classes for functional error handling.
///
/// Used with `Either<Failure, T>` from dartz to represent
/// domain-level errors without throwing exceptions.
@immutable
sealed class Failure {
  /// Creates a [Failure] with an optional [message], [statusCode] and [code].
  const Failure({this.message = '', this.statusCode, this.code});

  /// Human-readable error message.
  final String message;

  /// Optional HTTP status code associated with the failure.
  final int? statusCode;

  /// Backend typed error code (e.g. `AUTH_VERIFY_002`), when present. Lets
  /// callers map to precise copy instead of matching on [message].
  final String? code;

  @override
  String toString() => '$runtimeType(message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          statusCode == other.statusCode &&
          code == other.code;

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode, code);
}

/// Failure originating from a remote server error (5xx, unexpected response).
class ServerFailure extends Failure {
  /// Creates a [ServerFailure].
  const ServerFailure(
      {super.message = 'Server error occurred', super.statusCode, super.code});
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
    super.code,
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
