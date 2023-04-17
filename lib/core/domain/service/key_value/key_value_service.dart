abstract class KeyValueService {
  Future<void> setString(String key, String value);
  Future<String?> getString(String key);

  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);

  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);

  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);

  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);

  Future<void> remove(String key);
  Future<void> clear();

  Future<bool> containsKey(String key);

  Future<bool> get isEmpty;
  Future<bool> get isNotEmpty;
  Future<int> get length;
  Future<Set<String>> get keys;
}
