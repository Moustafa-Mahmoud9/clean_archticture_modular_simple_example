/// All API paths specific to the authentication feature.
/// Relative to [NetworkEnvironment.baseUrl].
class AuthEndPoints {
  AuthEndPoints._();

  static const String _mobile = '/front-user';
  static const String login = '$_mobile/login';
  static const String register = '$_mobile/register';
  static const String logout = '$_mobile/logout';
  static const String refresh = '$_mobile/refresh';
}
