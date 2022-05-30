/*

class SecureLocalStorage implements ILocalStorageDriver {
  late FlutterSecureStorage storage;

  SecureLocalStorage(this.storage);

  @override
  Future<bool> delete(String key) async {
    try {
      await storage.delete(key: key);
      return true;
    } on Exception {
      return false;
    }
  }

  @override
  Future<dynamic> get(String key) async {
    return await storage.read(key: key);
  }

  @override
  Future<bool> put(String key, String? value) async {
    try {
      await storage.write(key: key, value: value);
      return true;
    } on Exception {
      return false;
    }
  }
}
 */