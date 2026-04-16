import '../models/api_error_type.dart';

/// Thrown when the remote server returns an error response (4xx / 5xx).
class ServerException implements Exception {
  final String message;
  final int statusCode;

  const ServerException({
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() =>
      'ServerException(statusCode: $statusCode, message: $message)';
}

/// Thrown when reading from or writing to local cache fails.
class CacheException implements Exception {
  final String message;

  const CacheException({required this.message});

  @override
  String toString() => 'CacheException(message: $message)';
}

/// Thrown when there is no internet connection.
class NetworkException implements Exception {
  final String message;

  const NetworkException({required this.message});

  @override
  String toString() => 'NetworkException(message: $message)';
}

/// Thrown when a request or response exceeds the allowed time.
class TimeoutException implements Exception {
  final String message;

  const TimeoutException({required this.message});

  @override
  String toString() => 'TimeoutException(message: $message)';
}

/// Thrown when the server returns 401 Unauthorized.
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({required this.message});

  @override
  String toString() => 'UnauthorizedException(message: $message)';
}

/// Thrown when the response body cannot be parsed.
class ParseException implements Exception {
  final String message;

  const ParseException({required this.message});

  @override
  String toString() => 'ParseException(message: $message)';
}

// ── ApiErrorType → typed Exception mapper ────────────────────────────────────

/// Converts an [ApiErrorType] + message into the matching typed [Exception].
///
/// Used by datasources in the `failure` branch of `ApiResponse.when()`
/// so each datasource doesn't repeat its own switch statement.
///
/// Usage:
/// ```dart
/// response.when(
///   success: (data) => data,
///   failure: (error, message) => throwApiException(error, message),
/// );
/// ```
Never throwApiException(ApiErrorType error, String message) {
  switch (error) {
    case ApiErrorType.network:
      throw NetworkException(message: message);
    case ApiErrorType.timeout:
      throw TimeoutException(message: message);
    case ApiErrorType.unauthorized:
    case ApiErrorType.forbidden:
      throw UnauthorizedException(message: message);
    case ApiErrorType.parse:
      throw ParseException(message: message);
    case ApiErrorType.cancelled:
      throw NetworkException(message: message);
    case ApiErrorType.ssl:
      throw NetworkException(message: message);
    case ApiErrorType.server:
    case ApiErrorType.client:
    case ApiErrorType.unknown:
      throw ServerException(message: message, statusCode: 500);
  }
}