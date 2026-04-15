import 'package:core/core_package.dart';
import 'package:dio/dio.dart';

/// Bridges a core [ApiInterceptor] into Dio's [Interceptor] pipeline.
///
/// Feature packages and shared interceptors implement the pure-Dart
/// [ApiInterceptor] contract. This adapter is the single place where
/// that contract is translated into Dio's handler-based model.
///
/// Usage (inside DioClient):
/// ```dart
/// _dio.interceptors.add(DioApiInterceptorAdapter(HeaderInterceptor(...)));
/// ```
class DioApiInterceptorAdapter extends Interceptor {
  final ApiInterceptor _delegate;

  DioApiInterceptorAdapter(this._delegate);

  // ── onRequest ───────────────────────────────────────────────────────────

// ── onRequest ───────────────────────────────────────────────────────────

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    try {
      final details = RequestDetails(
        method: _methodFromString(options.method),
        path: options.path,
        data: options.data,
        headers: Map<String, dynamic>.from(options.headers),
        extra: Map<String, dynamic>.from(options.extra),
      );

      final updated = await _delegate.onRequest(details);

      // Write mutations back onto the outgoing RequestOptions.
      options
        ..method = updated.method.value
        ..path = updated.path
        ..data = updated.data;

      options.headers
        ..clear()
        ..addAll(updated.headers);

      options.extra
        ..clear()
        ..addAll(updated.extra);

      handler.next(options);
    } catch (e, st) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          stackTrace: st,
          type: DioExceptionType.unknown,
        ),
        true,
      );
    }
  }

  // ── onResponse ──────────────────────────────────────────────────────────

  @override
  Future<void> onResponse(
      Response response,
      ResponseInterceptorHandler handler,
      ) async {
    try {
      final details = ResponseDetails(
        data: response.data,
        statusCode: response.statusCode,
        headers: _flattenHeaders(response.headers),
      );

      final updated = await _delegate.onResponse(details);
      response.data = updated.data;
      handler.next(response);
    } catch (e, st) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          error: e,
          stackTrace: st,
          type: DioExceptionType.unknown,
        ),
        true,
      );
    }
  }

  // ── onError ─────────────────────────────────────────────────────────────

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    try {
      final details = ErrorDetails(
        message: err.message ?? 'Unknown error',
        statusCode: err.response?.statusCode,
        originalError: err,
      );

      final updated = await _delegate.onError(details);

      // Stash the normalised message where DioClient.request() can read it.
      err.requestOptions.extra['_normalizedError'] = updated.message;
      handler.next(err);
    } catch (_) {
      handler.next(err);
    }
  }

  // ── helpers ─────────────────────────────────────────────────────────────

  HttpMethod _methodFromString(String method) {
    final upper = method.toUpperCase();
    return HttpMethod.values.firstWhere(
          (m) => m.value == upper,
      orElse: () => HttpMethod.get,
    );
  }

  Map<String, dynamic> _flattenHeaders(Headers headers) {
    final out = <String, dynamic>{};
    headers.forEach((name, values) {
      out[name] = values.length == 1 ? values.first : values;
    });
    return out;
  }
}