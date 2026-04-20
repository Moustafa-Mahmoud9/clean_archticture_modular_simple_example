import 'package:core/core_package.dart';
import '../models/user_model.dart';
import 'package:core_implementation/core_implementation.dart';

class AuthEndpoints implements EndpointProvider {
  @override final String path;
  @override final HttpMethod method;
  @override final Map<String, dynamic>? queryParameters;
  @override final Map<String, dynamic>? body;
  @override final Map<String, String>? extraHeaders;

  const AuthEndpoints._({
    required this.path,
    required this.method,
    this.queryParameters,
    this.body,
    this.extraHeaders,
  });

  factory AuthEndpoints.login({
    required String email,
    required String password,
    required String phone,
  }) =>
      AuthEndpoints._(
        path: '/front-user/login',
        method: HttpMethod.post,
        body: {
          'email': email,
          'password': password,
          'phone': phone,
        },
      );

  factory AuthEndpoints.register({
    required String name,
    required String email,
    required String password,
  }) =>
      AuthEndpoints._(
        path: '/front-user/register',
        method: HttpMethod.post,
        body: {
          'name': name,
          'email': email,
          'password': password,
        },

      );

  factory AuthEndpoints.logout() => const AuthEndpoints._(
    path: '/front-user/logout',
    method: HttpMethod.post,
  );

  factory AuthEndpoints.refreshToken({required String refreshToken}) =>
      AuthEndpoints._(
        path: '/front-user/refresh',
        method: HttpMethod.post,
        body: {'refresh_token': refreshToken},
        extraHeaders: const {'sendToken': 'false'},
      );
}

// ── Datasource contract ──────────────────────────────────────────────────────

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
    required String phone,
  });

  Future<LoginModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();
}

// ── Datasource implementation ────────────────────────────────────────────────

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;

  AuthRemoteDataSourceImpl({required ApiClient client}) : _client = client;

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
    required String phone,
  }) async {
    final endpoint = AuthEndpoints.login(
      email: email,
      password: password,
      phone: phone,
    );

    final response = await _client.request<LoginModel>(
      endpoint.path,
      method: endpoint.method,
      endpointProvider: endpoint,
      fromJson: (json) => LoginModel.fromJson(json as Map<String, dynamic>),
    );

    return response.when(
      success: (data) => data,
      failure: (error, message) => throwApiException(error, message),
    );
  }

  @override
  Future<LoginModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final endpoint = AuthEndpoints.register(
      name: name,
      email: email,
      password: password,
    );

    final response = await _client.request<LoginModel>(
      endpoint.path,
      method: endpoint.method,
      endpointProvider: endpoint,
      fromJson: (json) => LoginModel.fromJson(json as Map<String, dynamic>),
    );

    return response.when(
      success: (data) => data,
      failure: (error, message) => throwApiException(error, message),
    );
  }

  @override
  Future<void> logout() async {
    final endpoint = AuthEndpoints.logout();

    final response = await _client.request<void>(
      endpoint.path,
      method: endpoint.method,
      endpointProvider: endpoint,
    );

    response.when(
      success: (_) {},
      failure: (error, message) => throwApiException(error, message),
    );
  }
}