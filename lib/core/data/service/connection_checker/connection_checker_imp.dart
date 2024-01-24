// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// 🌎 Project imports:
import '../../../domain/service/connection_checker/connection_checker.dart';

class ConnectionCheckerImp implements ConnectionChecker {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionCheckerImp _singleton =
      ConnectionCheckerImp._internal();
  ConnectionCheckerImp._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionCheckerImp getInstance() => _singleton;
  //This tracks the current connection status
  bool hasConnection = false;
  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();
  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  @override
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
  }

  ConnectionCheckerImp();

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    hasInternetInternetConnection();
  }

  @override
  Stream get connectionChange => connectionChangeController.stream;

  @override
  Future<bool> hasInternetInternetConnection() async {
    bool previousConnection = hasConnection;
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Check if device is just connect with mobile network or wifi
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      //Check there is actual internet connection with a mobile network or wifi
      if (await InternetConnectionChecker().hasConnection) {
        // Network data detected & internet connection confirmed.
        hasConnection = true;
      } else {
        // Network data detected but no internet connection found.
        hasConnection = false;
      }
    }
    // device has no mobile network and wifi connection at all
    else {
      hasConnection = false;
    }
    // The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}
