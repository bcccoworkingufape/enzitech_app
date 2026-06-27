// 🌎 Project imports:

// 🌎 Project imports:
import '../../../domain/service/key_value/key_value_service.dart';
import '../../../domain/service/user_preferences/user_preferences_service.dart';

class UserPreferencesServiceImp implements UserPreferencesService {
  static const _userKey = "user";
  static const _excludeConfirmationKey = "excludeConfirmationKey";
  static const _replaceLanguageKey = "replaceLanguageKey";
  static const _themeModeKey = "themeModeKey";
  //* Legacy token key kept for one-shot migration in main.dart. The active
  //* session token now lives in SecureSessionStorage (FlutterSecureStorage).
  static const legacyTokenKey = "token";

  final KeyValueService _keyValueService;

  UserPreferencesServiceImp(this._keyValueService);

  //* ACCOUNT
  @override
  Future<void> saveFullUser(String jsonEncoded) async {
    await _keyValueService.setString(_userKey, jsonEncoded);
  }

  @override
  Future<String?> getFullUser() async {
    return await _keyValueService.getString(_userKey);
  }

  //* Token persistence moved to SecureSessionStorage. These methods stay as
  //* pass-throughs to keep the legacy contract (and migration) safe.
  @override
  Future<void> saveToken(String token) async {
    // No-op: token writes go through SecureSessionStorage.
  }

  @override
  Future<String?> getToken() async {
    // Returns the legacy token only while the migration has not run yet.
    return await _keyValueService.getString(legacyTokenKey);
  }

  @override
  Future<void> removeToken() async {
    await _keyValueService.remove(legacyTokenKey);
  }

  //* PREFERENCES
  @override
  Future<void> initConfirmationsEnabled() async {
    await saveExcludeConfirmation(true);
  }

  @override
  Future<void> saveExcludeConfirmation(bool value) async {
    await _keyValueService.setBool(_excludeConfirmationKey, value);
  }

  @override
  Future<bool> getExcludeConfirmation() async {
    return await _keyValueService.getBool(_excludeConfirmationKey) ?? false;
  }

  @override
  Future<void> saveReplaceLanguage(bool value) async {
    return await _keyValueService.setBool(_replaceLanguageKey, value);
  }

  @override
  Future<bool> getReplaceLanguage() async {
    return await _keyValueService.getBool(_replaceLanguageKey) ?? false;
  }

  @override
  Future<void> initThemeMode() async {
    await saveThemeModeAsString('system');
  }

  @override
  Future<void> saveThemeModeAsString(String value) async {
    await _keyValueService.setString(_themeModeKey, value);
  }

  @override
  Future<String> getThemeModeAsString() async {
    return await _keyValueService.getString(_themeModeKey) ?? 'light';
  }

  //* GENERAL
  @override
  Future<void> clearAll() async {
    await _keyValueService.clear();
  }

  @override
  Future<void> clearAllAndKeepTheme() async {
    String theme = await getThemeModeAsString();
    await _keyValueService.clear();
    await saveThemeModeAsString(theme);
  }
}
