abstract class UserPreferencesServices {
  // ACCOUNT
  Future<void> saveFullUser(String jsonEncoded);

  Future<String?> getFullUser();

  Future<void> saveToken(String token);

  Future<String?> getToken();

  Future<void> removeToken();

  // PREFERENCES
  Future<void> initConfirmationsEnabled();

  Future<void> saveExcludeConfirmation(bool value);

  Future<bool> getExcludeConfirmation();

  Future<void> initThemeMode();

  Future<void> saveThemeModeAsString(String value);

  Future<String> getThemeModeAsString();

  // GENERAL
  Future<void> clearAll();

  Future<void> clearAllAndKeepTheme();
}
