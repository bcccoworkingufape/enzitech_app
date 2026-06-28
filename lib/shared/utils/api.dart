// ignore: deprecated_member_use_from_same_package
// ignore_for_file: constant_identifier_names, non_constant_identifier_names
// 🌎 Project imports:
import '../../core/enums/enums.dart';

class API {
  static const String _baseUrl = 'baseUrl';
  static const String _devBaseUrlDefine = String.fromEnvironment('DEV_API_BASE_URL');
  static const String _stageBaseUrlDefine = String.fromEnvironment('STAGE_API_BASE_URL');
  static const String _prodBaseUrlDefine = String.fromEnvironment('PROD_API_BASE_URL');
  static const String _defaultDevBaseUrl = "https://enzitech.onrender.com";
  static const String _defaultProdBaseUrl = "http://200.133.6.201:30001/";

  static Map<String, dynamic> _config = {};
  static late EnvironmentEnum enviroment;

  /// Seleciona o ambiente de execução.
  ///
  /// O padrão respeita o parâmetro `--dart-define=ENV=dev|stage|prod` e
  /// retorna para produção quando o parâmetro está ausente para manter o
  /// comportamento anterior para clientes downstream.
  static void setEnvironment(EnvironmentEnum env) {
    switch (env) {
      case EnvironmentEnum.dev:
        _config = devConstants;
        enviroment = EnvironmentEnum.dev;
        break;
      case EnvironmentEnum.stage:
        _config = stageConstants; //? NO STAGE API YET
        enviroment = EnvironmentEnum.stage;
        break;
      case EnvironmentEnum.prod:
        _config = prodConstants;
        enviroment = EnvironmentEnum.prod;
        break;
    }
  }

  /// Resolve o ambiente ativo a partir de `--dart-define=ENV=...`.
  static EnvironmentEnum environmentFromDefine() {
    const value = String.fromEnvironment('ENV', defaultValue: 'prod');
    switch (value) {
      case 'dev':
        return EnvironmentEnum.dev;
      case 'stage':
        return EnvironmentEnum.stage;
      case 'prod':
      default:
        return EnvironmentEnum.prod;
    }
  }

  static dynamic get apiBaseUrl {
    return _config[_baseUrl];
  }

  //-> SETUP
  static String _baseUrlFromDefine({required String value, required String fallback}) {
    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? fallback : trimmedValue;
  }

  static Map<String, dynamic> devConstants = {
    _baseUrl: _baseUrlFromDefine(value: _devBaseUrlDefine, fallback: _defaultDevBaseUrl),
  };

  static Map<String, dynamic> stageConstants = {
    _baseUrl: _baseUrlFromDefine(value: _stageBaseUrlDefine, fallback: _defaultDevBaseUrl),
  };

  // TODO: URL base de produção. Temporariamente é servida em texto puro enquanto o
  /// backend é migrado para TLS. O host legado está em lista de permissões em
  /// `SecureNetworkConfig` para permitir que builds de release iniciem até a
  /// conclusão da migração.
  // ignore: deprecated_member_use_from_same_package
  static Map<String, dynamic> prodConstants = {
    _baseUrl: _baseUrlFromDefine(value: _prodBaseUrlDefine, fallback: _defaultProdBaseUrl),
  };

  //-> AUTHENTICATION
  /// Rota para '/auth'
  static const _REQUEST_AUTH = '/auth';

  /// Rota para '/auth/login'
  static const REQUEST_LOGIN = '$_REQUEST_AUTH/login';

  /// Rota para '/auth/send-recover-email'
  static const REQUEST_RECOVER_EMAIL = '$_REQUEST_AUTH/send-recover-email';

  /// Rota para '/auth/send-recover-email/$token'
  static String REQUEST_RESET_PASSWORD(String token) => '$REQUEST_RECOVER_EMAIL/$token';

  //-> USER
  /// Rota para '/users'
  static const REQUEST_USERS = '/users';

  /// Rota para '/users/$id'
  static String REQUEST_USERS_WITH_ID(String id) => '$REQUEST_USERS/$id';

  //-> ENZYMES
  /// Rota para '/enzymes'
  static const REQUEST_ENZYMES = '/enzymes';

  /// Rota para '/enzymes/$id'
  static String REQUEST_ENZYMES_WITH_ID(String id) => '$REQUEST_ENZYMES/$id';

  //-> TREATMENTS
  /// Rota para '/processes'
  static const REQUEST_TREATMENTS = '/processes';

  /// Rota para '/processes/$id'
  static String REQUEST_TREATMENTS_WITH_ID(String id) => '$REQUEST_TREATMENTS/$id';

  //-> EXPERIMENTS
  /// Rota para '/experiments'
  static const REQUEST_EXPERIMENTS = '/experiments';

  /// Rota para '/experiments/$id'
  static String REQUEST_EXPERIMENTS_WITH_ID(String id) => '$REQUEST_EXPERIMENTS/$id';

  /// Rota para '/experiments/calculate/$experiment'
  static String REQUEST_CALCULATE_EXPERIMENTS(String experiment) => '$REQUEST_EXPERIMENTS/calculate/$experiment';

  /// Rota para '/experiments/save-result/$experiment'
  static String REQUEST_SAVE_RESULT_EXPERIMENTS(String experiment) => '$REQUEST_EXPERIMENTS/save-result/$experiment';

  /// Rota para '/experiments/save-result/$experiment'
  static String REQUEST_GET_RESULT_EXPERIMENTS(String experiment) =>
      '$REQUEST_EXPERIMENTS/get-total-result/$experiment';

  /// Rota para '/experiments/get-total-result/$experiment'
  static String REQUEST_TOTAL_RESULTS_OF_EXPERIMENT(String experiment) =>
      '$REQUEST_EXPERIMENTS/get-total-result/$experiment';

  /// Rota para '/experiments/get-enzymes/$experiment'
  static String REQUEST_ENZYMES_REMAINING_IN_EXPERIMENT(String experiment) =>
      '$REQUEST_EXPERIMENTS/get-enzymes/$experiment';
}
