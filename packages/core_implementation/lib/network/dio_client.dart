import 'dart:io';
import 'package:core/core_package.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_response_impl.dart';
import 'dio_api_interceptor_adapter.dart';
import 'dio_cancel_token.dart';
import 'dio_interceptor.dart';

/// Concrete [ApiClient] implementation using Dio.
///
/// Every configuration decision flows from [ApiEnvironment] — base URL,
/// timeouts, logging, SSL pinning, base headers.
///
/// Interceptors fall into two groups:
///   • Transform-only interceptors implement the core [ApiInterceptor]
///     contract and are wired in via [DioApiInterceptorAdapter].
///   • [AuthInterceptor] is a raw Dio [Interceptor] because its 401
///     refresh-and-retry flow needs Dio-native handler control.
///
/// Example registration:
/// ```dart
/// sl.registerLazySingleton<ApiClient>(
///   () => DioClient(
///     environment: sl<ApiEnvironment>(),
///     tokenProvider: sl<TokenProvider>(),
///     additionalInterceptors: [
///       DeviceMetadataInterceptor(
///         getLanguage: () => sl<StorageService>().read(key: 'lang'),
///         getDeviceId: () async {
///           final uuid = await MobileDeviceIdentifier().getDeviceId();
///           return '${Platform.isIOS ? 'IOS' : 'ANDROID'}-$uuid';
///         },
///         getLocation: () => sl<LocationService>().getLocation(),
///       ),
///     ],
///   ),
/// );
/// ```
class DioClient extends ApiClient {
  late final Dio _dio;
  final ApiEnvironment environment;
  bool _loggerAttached = false;

  DioClient({
    required this.environment,
    TokenProvider? tokenProvider,
    List<ApiInterceptor> additionalInterceptors = const [],
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl:environment.baseUrl,
        connectTimeout: environment.connectTimeout,
        receiveTimeout: environment.receiveTimeout,
        sendTimeout: environment.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...environment.headers,
        },
      ),
    );

    _registerInterceptors(tokenProvider, additionalInterceptors);

    if (environment.sslPinningEnabled) {
      applySslPinning(environment.certificateAssetPath!);
    }

    if (environment.enableLogger) {
      applyLogger();
    }
  }

  // ── Interceptor registration ────────────────────────────────────────────

  void _registerInterceptors(
      TokenProvider? tokenProvider,
      List<ApiInterceptor> additional,
      ) {
    // 1. Auth — raw Dio interceptor, first so token is attached before all else.
    if (tokenProvider != null) {
      _dio.interceptors.add(
        AuthInterceptor(tokenProvider: tokenProvider, dio: _dio),
      );
    }

    // 2. Error normaliser — runs on errors before caller-supplied interceptors
    //    so they see a clean message.
    _dio.interceptors.add(DioApiInterceptorAdapter(ErrorNormalizerInterceptor()));

    // 3. Caller-supplied interceptors (DeviceMetadata, analytics, etc.).
    for (final ai in additional) {
      _dio.interceptors.add(DioApiInterceptorAdapter(ai));
    }

    // Logger is added in applyLogger() — always last so it sees final request.
  }

  // ── ApiClient overrides ─────────────────────────────────────────────────

  @override
  Future<void> applySslPinning(String assetPath) async {
    final certBytes = await rootBundle.load(assetPath);
    final secCtx = SecurityContext(withTrustedRoots: false)
      ..setTrustedCertificatesBytes(certBytes.buffer.asUint8List());

    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
        () => HttpClient(context: secCtx)
      ..badCertificateCallback = (_, __, ___) => false;
  }

  @override
  Future<void> applyLogger({bool verbose = false}) async {
    if (_loggerAttached) return; // idempotent
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: verbose,
        requestBody: true,
        responseBody: true,
        responseHeader: verbose,
        error: true,
        compact: !verbose,
      ),
    );
    _loggerAttached = true;
  }

  // ── Core request engine ─────────────────────────────────────────────────

  @override
  Future<ApiResponse<T>> request<T>(
      String path, {
        required HttpMethod method,
        EndpointProvider? endpointProvider,
        T Function(dynamic json)? fromJson,
        ApiCancelToken? cancelToken,
        ApiProgressCallback? onSendProgress,
        ApiProgressCallback? onReceiveProgress,
      }) async
  {
    try {
      final resolvedPath = endpointProvider?.path ?? path;
      final resolvedBody = endpointProvider?.body;
      final resolvedQuery = endpointProvider?.queryParameters;
      final resolvedMethod = (endpointProvider?.method ?? method).value;

      final dioOptions = Options(
        method: resolvedMethod,
        headers: endpointProvider?.extraHeaders,
      );

      final dioCancelToken =
      cancelToken is DioApiCancelToken ? cancelToken.dioToken : null;

      final response = await _dio.request<dynamic>(
        resolvedPath,
        data: resolvedBody,
        queryParameters: resolvedQuery,
        options: dioOptions,
        cancelToken: dioCancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      final T parsed;
      try {
        parsed = fromJson != null
            ? fromJson(response.data)
            : response.data as T;
      } catch (_) {
        return ApiFailure<T>(
          error: ApiErrorType.parse,
          message: 'Failed to parse server response.',
          statusCode: response.statusCode,
        );
      }

      return ApiSuccess<T>(
        data: parsed,
        statusCode: response.statusCode,
        message: _extractMessage(response.data),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return ApiFailure<T>(
          error: ApiErrorType.cancelled,
          message: 'Request was cancelled.',
        );
      }
      return ApiFailure<T>(
        message: e.requestOptions.extra['_normalizedError'] as String? ??
            e.message ??
            'Unknown error',
        error: _toErrorType(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiFailure<T>(
        error: ApiErrorType.unknown,
        message: e.toString(),
      );
    }
  }

  // ── File upload ─────────────────────────────────────────────────────────

  @override
  Future<ApiResponse<T>> uploadFile<T>(
      String path, {
        required String filePath,
        required FileExtension fileType,
        String fileField = 'file',
        Map<String, String> extraFields = const {},
        T Function(dynamic json)? fromJson,
        ApiCancelToken? cancelToken,
        ApiProgressCallback? onSendProgress,
      }) async {
    try {
      final fileName = filePath.split(RegExp(r'[/\\]')).last;
      final formData = FormData.fromMap({
        fileField: await MultipartFile.fromFile(
          filePath,
          filename: fileName,
          contentType: MediaType.parse(fileType.mimeType),
        ),
        ...extraFields,
      });

      final dioCancelToken =
      cancelToken is DioApiCancelToken ? cancelToken.dioToken : null;

      final response = await _dio.post<dynamic>(
        path,
        data: formData,
        cancelToken: dioCancelToken,
        onSendProgress: onSendProgress,
        options: Options(contentType: 'multipart/form-data'),
      );

      final T parsed;
      try {
        parsed = fromJson != null
            ? fromJson(response.data)
            : response.data as T;
      } catch (_) {
        return ApiFailure<T>(
          error: ApiErrorType.parse,
          message: 'Failed to parse upload response.',
          statusCode: response.statusCode,
        );
      }

      return ApiSuccess<T>(data: parsed, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiFailure<T>(
        error: _toErrorType(e),
        message: e.requestOptions.extra['_normalizedError'] as String? ??
            e.message ??
            'Upload failed.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiFailure<T>(
        error: ApiErrorType.unknown,
        message: e.toString(),
      );
    }
  }

  // ── File download ───────────────────────────────────────────────────────

  @override
  Future<ApiResponse<String>> downloadFile(
      String path, {
        required String savePath,
        required FileExtension fileType,
        Map<String, dynamic>? queryParameters,
        ApiCancelToken? cancelToken,
        ApiProgressCallback? onReceiveProgress,
      }) async {
    try {
      final dioCancelToken =
      cancelToken is DioApiCancelToken ? cancelToken.dioToken : null;

      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        cancelToken: dioCancelToken,
        onReceiveProgress: onReceiveProgress,
        options: Options(headers: {'Accept': fileType.mimeType}),
      );

      return ApiSuccess<String>(data: savePath, statusCode: 200);
    } on DioException catch (e) {
      return ApiFailure<String>(
        error: _toErrorType(e),
        message: e.requestOptions.extra['_normalizedError'] as String? ??
            e.message ??
            'Download failed.',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiFailure<String>(
        error: ApiErrorType.unknown,
        message: e.toString(),
      );
    }
  }

  // ── Private helpers ─────────────────────────────────────────────────────

  ApiErrorType _toErrorType(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiErrorType.timeout;
      case DioExceptionType.connectionError:
        return ApiErrorType.network;
      case DioExceptionType.badCertificate:
        return ApiErrorType.ssl;
      case DioExceptionType.cancel:
        return ApiErrorType.cancelled;
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode ?? 0;
        if (code == 401) return ApiErrorType.unauthorized;
        if (code == 403) return ApiErrorType.forbidden;
        if (code >= 500) return ApiErrorType.server;
        return ApiErrorType.client;
      case DioExceptionType.unknown:
        return ApiErrorType.unknown;
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return (data['message'] ?? data['msg'])?.toString();
    }
    return null;
  }

  /// Exposes raw Dio — for test stubbing only. Never use in feature code.
  Dio get rawDio => _dio;
}