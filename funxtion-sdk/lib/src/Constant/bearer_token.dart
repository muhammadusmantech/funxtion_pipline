abstract class BearerToken {
  static String? _token;

  static String get getToken => _token.toString();
  static set setToken(String token) {
    _token = token;
  }
}
