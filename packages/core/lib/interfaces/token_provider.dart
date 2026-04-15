abstract class TokenProvider {
  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();


  Future<String> refreshAccessToken();

  Future<void> saveAccessToken(String token);

  Future<void> onUnauthorized();
}