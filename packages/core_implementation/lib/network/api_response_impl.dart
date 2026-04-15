import 'package:core/core_package.dart';
// ── ApiSuccess ────────────────────────────────────────────────────────────────

/// The success branch of [ApiResponse].
/// Returned when the HTTP call succeeds and the response is parsed correctly.
class ApiSuccess<T> extends ApiResponse<T> {
  final T data;
  final int? statusCode;
  final String? message;

  const ApiSuccess({
    required this.data,
    this.statusCode,
    this.message,
  });

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiErrorType error, String message) failure,
  }) =>
      success(data);
}

// ── ApiFailure ────────────────────────────────────────────────────────────────

/// The failure branch of [ApiResponse].
/// Returned when any error occurs — network, timeout, server, parse, etc.
class ApiFailure<T> extends ApiResponse<T> {
  final ApiErrorType error;
  final String message;
  final int? statusCode;

  const ApiFailure({
    required this.error,
    required this.message,
    this.statusCode,
  });

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiErrorType error, String message) failure,
  }) =>
      failure(error, message);
}