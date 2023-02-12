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

  // GENERAL
  Future<void> clearAll();
}
