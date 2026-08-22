// 🎯 Dart imports:
import 'dart:async';

// 📦 Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

// 🌎 Project imports:
import '../../../domain/service/connection_checker/connection_checker.dart';

class ConnectionCheckerImp implements ConnectionChecker {
  // Isso cria a instância única chamando o construtor `_internal` especificado abaixo.
  static final ConnectionCheckerImp _singleton = ConnectionCheckerImp._internal();
  ConnectionCheckerImp._internal();

  // Isso é usado para recuperar a instância pelo app.
  static ConnectionCheckerImp getInstance() => _singleton;
  // Isso acompanha o status atual da conexão.
  bool hasConnection = false;
  // Isso permite assinar mudanças de conexão.
  StreamController connectionChangeController = StreamController.broadcast();
  // flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  @override
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChangeList);
  }

  ConnectionCheckerImp();

  // Listener do flutter_connectivity para List<ConnectivityResult>.
  void _connectionChangeList(List<ConnectivityResult> results) {
    // Você pode tratar vários resultados, se necessário; aqui apenas verificamos o primeiro.
    if (results.isNotEmpty) {
      hasInternetInternetConnection();
    }
  }

  @override
  Stream get connectionChange => connectionChangeController.stream;

  @override
  Future<bool> hasInternetInternetConnection() async {
    bool previousConnection = hasConnection;

    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());

    // Verifica se o dispositivo está conectado por rede móvel ou Wi-Fi.
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      // Verifica se há conexão real com a internet por rede móvel ou Wi-Fi.
      if (await InternetConnectionChecker.createInstance().hasConnection) {
        // Dados de rede detectados e conexão com a internet confirmada.
        hasConnection = true;
      } else {
        // Dados de rede detectados, mas nenhuma conexão com a internet foi encontrada.
        hasConnection = false;
      }
    }
    // O dispositivo não possui rede móvel nem conexão Wi-Fi.
    else {
      hasConnection = false;
    }
    // O status da conexão mudou; enviamos uma atualização para todos os listeners.
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }
    return hasConnection;
  }
}
