// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/shared_prefs.dart';

class UserPrefsServices {
  final String _tokenKey = "token";
  final String _userKey = "user";

  final ISharedPrefs _prefs = SharedPrefs();

  Future<void> saveFullUser(String jsonEncoded) async {
    await _prefs.setString(_userKey, jsonEncoded);
  }

  Future<String?> getFullUser() async {
    return await _prefs.getString(_userKey);
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return await _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
