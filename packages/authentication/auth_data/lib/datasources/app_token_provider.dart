import 'package:core/core_package.dart';
import 'package:core_implementation/core_implementation.dart';
/// Concrete [TokenProvider] for the auth feature.
///
/// Lives in auth_data. Has NO dependency on Dio, flutter_secure_storage,
/// or any HTTP library — storage comes in as the abstract [StorageService],
/// and the refresh network call comes in as a callback. The composition
/// root (injection_container) wires the concrete refresh implementation.
class AppTokenProvider implements TokenProvider {
  final StorageService _storage;           // ← abstract

  final Future<Map<String, dynamic>> Function(String refreshToken) _refreshCall;

  AppTokenProvider({
    required StorageService storage,       // ← abstract
    required Future<Map<String, dynamic>> Function(String refreshToken)
    refreshCall,
  })  : _storage = storage,
        _refreshCall = refreshCall;

  // ── TokenProvider contract ──────────────────────────────────────────────

  @override
  Future<String?> getAccessToken() => _storage.read(key: 'access_token');

  @override
  Future<String?> getRefreshToken() => _storage.read(key: 'refresh_token');

  @override
  Future<String> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw const UnauthorizedException(
        message: 'No refresh token available.',
      );
    }

    final data = await _refreshCall(refreshToken);

    final newAccessToken = data['access_token'] as String?;
    if (newAccessToken == null) {
      throw const UnauthorizedException(
        message: 'Refresh response missing access_token.',
      );
    }

    final newRefreshToken = data['refresh_token'] as String?;

    await _storage.write(key: 'access_token', value: newAccessToken);
    if (newRefreshToken != null) {
      await _storage.write(key: 'refresh_token', value: newRefreshToken);
    }

    return newAccessToken;
  }

  @override
  Future<void> onUnauthorized() async {
    await _storage.deleteAll();
    // TODO: trigger navigation to login via your router or a broadcast stream.
  }

  // ── Helpers used by AuthLocalDataSource ─────────────────────────────────

  /// Saves the access token received from a login/register response.
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: 'access_token', value: token);
}