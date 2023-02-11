import '../../../domain/service/key_value/key_value_service.dart';
import '../../../failures/failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsServiceImp implements KeyValueService {
  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      throw NoResultQueryFailure();
    }
  }

  @override
  Future<void> setInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  @override
  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  @override
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }

  @override
  Future<bool> get isEmpty async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().isEmpty;
  }

  @override
  Future<bool> get isNotEmpty async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().isNotEmpty;
  }

  @override
  Future<int> get length async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys().length;
  }

  @override
  Future<Set<String>> get keys async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }
}
