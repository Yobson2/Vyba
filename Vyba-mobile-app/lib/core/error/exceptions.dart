/// Exception classes thrown in the data layer.
///
/// These are caught in repository implementations and
/// mapped to corresponding [Failure] types.

/// Exception thrown when a server request fails.
class ServerException implements Exception {
  /// Creates a [ServerException].
  const ServerException(
      {this.message = 'Server error', this.statusCode, this.code});

  /// Error message from the server.
  final String message;

  /// HTTP status code.
  final int? statusCode;

  /// Backend typed error code (e.g. `AUTH_VERIFY_002`), when present.
  final String? code;

  @override
  String toString() =>
      'ServerException(message: $message, statusCode: $statusCode, code: $code)';
}

/// Exception thrown when a cache operation fails.
class CacheException implements Exception {
  /// Creates a [CacheException].
  const CacheException({this.message = 'Cache error'});

  /// Error message.
  final String message;

  @override
  String toString() => 'CacheException(message: $message)';
}

/// Exception thrown when there is no network connectivity.
class NetworkException implements Exception {
  /// Creates a [NetworkException].
  const NetworkException({this.message = 'No internet connection'});

  /// Error message.
  final String message;

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// Exception thrown for unauthorized access (401/403).
class UnauthorizedException implements Exception {
  /// Creates an [UnauthorizedException].
  const UnauthorizedException({this.message = 'Unauthorized', this.code});

  /// Error message.
  final String message;

  /// Backend typed error code (e.g. `AUTH_ACCOUNT_003`), when present.
  final String? code;

  @override
  String toString() => 'UnauthorizedException(message: $message, code: $code)';
}
