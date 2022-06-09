// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/shared_prefs.dart';

class UserPrefsServices {
  final String _nameKey = "name";
  final String _tokenKey = "token";
  final String _emailKey = "email";

  final ISharedPrefs _prefs = SharedPrefs();

  Future<void> saveName(String userName) async {
    await _prefs.setString(_nameKey, userName);
  }

  Future<String?> getName() async {
    return await _prefs.getString(_nameKey);
  }

  Future<void> removeName() async {
    await _prefs.remove(_nameKey);
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

  Future<void> saveEmail(String email) async {
    await _prefs.setString(_emailKey, email);
  }

  Future<String?> getEmail() async {
    return await _prefs.getString(_emailKey);
  }

  Future<void> removeEmail() async {
    await _prefs.remove(_emailKey);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
