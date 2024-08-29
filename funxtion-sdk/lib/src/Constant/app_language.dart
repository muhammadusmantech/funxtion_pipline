class AppLanguage {
  static String? _languageCode;

  static String? get getLanguageCode => _languageCode.toString();
  static set setLanguageCode(String? languageCode) {
    _languageCode = languageCode;
  }
}
