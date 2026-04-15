import 'dart:io';
import 'package:core/core_package.dart';
import 'package:dio/dio.dart';

// ═════════════════════════════════════════════════════════════════════════════
//
// Convention:
//   - Interceptors that simply transform request/response/error data
//     implement the core [ApiInterceptor] contract and are wired into Dio
//     via [DioApiInterceptorAdapter]. They know nothing about Dio.
//
//   - [AuthInterceptor] needs Dio-native control flow (queueing parallel 401s,
//     refreshing once, retrying the original RequestOptions). That cannot be
//     expressed through [ApiInterceptor] without leaking Dio concepts into
//     core. So it is deliberately a raw Dio [Interceptor].
//
// ═════════════════════════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────────────────────────────────
// Base — no-op defaults so subclasses only override what they need.
// ─────────────────────────────────────────────────────────────────────────────

abstract class BaseApiInterceptor implements ApiInterceptor {
  @override
  Future<RequestDetails> onRequest(RequestDetails details) async => details;

  @override
  Future<ResponseDetails> onResponse(ResponseDetails details) async => details;

  @override
  Future<ErrorDetails> onError(ErrorDetails details) async => details;
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Auth interceptor — raw Dio. Handles 401 with refresh + retry + queueing.
// ─────────────────────────────────────────────────────────────────────────────

class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;
  final Dio _dio;

  bool _isRefreshing = false;
  final List<({
  RequestOptions options,
  ErrorInterceptorHandler handler,
  })> _pendingQueue = [];

  AuthInterceptor({
    required TokenProvider tokenProvider,
    required Dio dio,
  })  : _tokenProvider = tokenProvider,
        _dio = dio;

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final sendToken = options.extra['sendToken'] as bool? ?? true;
    if (!sendToken) {
      handler.next(options);
      return;
    }

    final token = await _tokenProvider.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final refreshToken = await _tokenProvider.getRefreshToken();
    if (refreshToken == null) {
      await _tokenProvider.onUnauthorized();
      handler.next(err);
      return;
    }

    if (_isRefreshing) {
      _pendingQueue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;
    try {
      final newToken = await _tokenProvider.refreshAccessToken();
      await _retryRequest(err.requestOptions, newToken, handler);
      for (final p in _pendingQueue) {
        await _retryRequest(p.options, newToken, p.handler);
      }
    } catch (_) {
      for (final p in _pendingQueue) {
        p.handler.next(err);
      }
      await _tokenProvider.onUnauthorized();
      handler.next(err);
    } finally {
      _isRefreshing = false;
      _pendingQueue.clear();
    }
  }

  Future<void> _retryRequest(
      RequestOptions originalOptions,
      String newToken,
      ErrorInterceptorHandler handler,
      ) async {
    originalOptions.headers['Authorization'] = 'Bearer $newToken';
    try {
      final retryResponse = await _dio.fetch(originalOptions);
      handler.resolve(retryResponse);
    } on DioException catch (retryErr) {
      handler.next(retryErr);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Error normaliser — converts error details to a human-readable message.
// ─────────────────────────────────────────────────────────────────────────────

class ErrorNormalizerInterceptor extends BaseApiInterceptor {
  @override
  Future<ErrorDetails> onError(ErrorDetails details) async {
    return ErrorDetails(
      message: _toMessage(details),
      statusCode: details.statusCode,
      originalError: details.originalError,
    );
  }

  String _toMessage(ErrorDetails d) {
    final original = d.originalError;

    if (original is DioException) {
      switch (original.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Request timed out. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        case DioExceptionType.badCertificate:
          return 'SSL certificate error.';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.badResponse:
        case DioExceptionType.unknown:
          break;
      }
      final body = original.response?.data;
      if (body is Map) {
        final msg = body['message'] ?? body['msg'] ?? body['error'];
        if (msg != null) return msg.toString();
      }
    }

    final code = d.statusCode;
    if (code == 401) return 'Unauthorized. Please log in again.';
    if (code == 403) return 'You do not have permission to do this.';
    if (code != null && code >= 500) return 'Server error. Please try later.';
    if (code != null && code >= 400) return 'Request failed with status $code.';

    return d.message;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Device metadata interceptor — attaches device/location headers.
// ─────────────────────────────────────────────────────────────────────────────

class DeviceMetadataInterceptor extends BaseApiInterceptor {
  final Future<String?> Function() getLanguage;
  final Future<String?> Function() getDeviceId;
  final Future<Map<String, double>?> Function()? getLocation;

  DeviceMetadataInterceptor({
    required this.getLanguage,
    required this.getDeviceId,
    this.getLocation,
  });

  @override
  Future<RequestDetails> onRequest(RequestDetails details) async {
    final lang = await getLanguage() ?? 'ar';
    final deviceId = await getDeviceId() ?? '';
    final platform = Platform.isIOS ? 'ios' : 'android';

    details.headers.addAll({
      'lang': lang,
      'mobileOs': platform,
      'mobileUuid': deviceId,
      'isMobile': 'true',
    });

    final location = await getLocation?.call();
    if (location != null) {
      final lat = location['latitude'];
      final lng = location['longitude'];
      if (lat != null) details.headers['latitude'] = lat.toString();
      if (lng != null) details.headers['longitude'] = lng.toString();
    }

    return details;
  }
}