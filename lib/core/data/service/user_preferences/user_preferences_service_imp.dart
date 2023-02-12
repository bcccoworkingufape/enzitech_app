// 🌎 Project imports:
import '../../../domain/service/key_value/key_value_service.dart';
import '../../../domain/service/user_preferences/user_preferences_service.dart';

class UserPreferencesServicesImp implements UserPreferencesServices {
  static const _tokenKey = "token";
  static const _userKey = "user";
  static const _excludeConfirmationKey = "excludeConfirmationKey";

  final KeyValueService _keyValueService;

  UserPreferencesServicesImp(this._keyValueService);

  // ACCOUNT
  @override
  Future<void> saveFullUser(String jsonEncoded) async {
    await _keyValueService.setString(_userKey, jsonEncoded);
  }

  @override
  Future<String?> getFullUser() async {
    return await _keyValueService.getString(_userKey);
  }

  @override
  Future<void> saveToken(String token) async {
    await _keyValueService.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return await _keyValueService.getString(_tokenKey);
  }

  @override
  Future<void> removeToken() async {
    await _keyValueService.remove(_tokenKey);
  }

  // PREFERENCES
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

  // GENERAL
  @override
  Future<void> clearAll() async {
    await _keyValueService.clear();
  }
}
