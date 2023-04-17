abstract class ConnectionChecker {
  void initialize();

  Stream get connectionChange;

  Future<bool> hasInternetInternetConnection();
}
