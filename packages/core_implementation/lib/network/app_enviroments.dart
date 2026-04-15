import 'package:core/core_package.dart';
// ── Development ───────────────────────────────────────────────────────────────

/// Development environment — logging on, no SSL pinning, relaxed timeouts.
///
/// Usage:
/// ```dart
/// sl.registerLazySingleton<ApiEnvironment>(
///   () => DevelopmentEnvironment(
///     baseUrl: 'https://dev-api.example.com',
///   ),
/// );
/// ```
class DevelopmentEnvironment extends ApiEnvironment {
  DevelopmentEnvironment({
    required super.baseUrl,
    super.connectTimeout = const Duration(seconds: 60),
    super.receiveTimeout = const Duration(seconds: 60),
    super.sendTimeout    = const Duration(seconds: 60),
    super.headers        = const {},
  }) : super(
    enableLogger:          true,
    certificateAssetPath:  null, // no SSL pinning in dev
  );
}

// ── Staging ───────────────────────────────────────────────────────────────────

/// Staging environment — logging on, optional SSL pinning.
///
/// Usage:
/// ```dart
/// sl.registerLazySingleton<ApiEnvironment>(
///   () => StagingEnvironment(
///     baseUrl: 'https://staging-api.example.com',
///   ),
/// );
/// ```
class StagingEnvironment extends ApiEnvironment {
  StagingEnvironment({
    required super.baseUrl,
    super.connectTimeout         = const Duration(seconds: 60),
    super.receiveTimeout         = const Duration(seconds: 60),
    super.sendTimeout            = const Duration(seconds: 60),
    super.headers                = const {},
    super.certificateAssetPath,  // optional — enable if staging uses pinning
  }) : super(
    enableLogger: true,
  );
}

// ── Production ────────────────────────────────────────────────────────────────

/// Production environment — logging off, SSL pinning supported.
///
/// Usage:
/// ```dart
/// sl.registerLazySingleton<ApiEnvironment>(
///   () => ProductionEnvironment(
///     baseUrl: 'https://api.example.com',
///     certificateAssetPath: 'assets/certs/api.cer', // optional
///   ),
/// );
/// ```
class ProductionEnvironment extends ApiEnvironment {
  ProductionEnvironment({
    required super.baseUrl,
    super.connectTimeout        = const Duration(seconds: 60),
    super.receiveTimeout        = const Duration(seconds: 60),
    super.sendTimeout           = const Duration(seconds: 60),
    super.headers               = const {},
    super.certificateAssetPath, // provide to enable SSL pinning
  }) : super(
    enableLogger: false,
  );
}