// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import '../../core/enums/enums.dart';

class API {
  static const String _baseUrl = 'baseUrl';

  static Map<String, dynamic> _config = {};
  static late EnvironmentEnum enviroment;

  static void setEnvironment(EnvironmentEnum env) {
    switch (env) {
      case EnvironmentEnum.dev:
        _config = devConstants;
        enviroment = EnvironmentEnum.dev;
        break;
      case EnvironmentEnum.stage:
        _config = stageConstants;
        enviroment = EnvironmentEnum.stage;
        break;
      case EnvironmentEnum.prod:
        _config = prodConstants;
        enviroment = EnvironmentEnum.prod;
        break;
    }
  }

  static dynamic get apiBaseUrl {
    return _config[_baseUrl];
  }

  static Map<String, dynamic> devConstants = {
    _baseUrl: "http://191.101.78.251:3010/",
  };

  static Map<String, dynamic> stageConstants = {
    _baseUrl: "https://ec2-54-161-87-5.compute-1.amazonaws.com:8080",
  };

  static Map<String, dynamic> prodConstants = {
    _baseUrl: "http://200.133.6.201:30001/",
  };

  //-> SETUP
  //! This must be removed from here
  static const BASE_URL_WEVERTON = 'http://08f7-128-201-207-230.ngrok.io/';
  static const BASE_URL_AMAZON =
      'https://ec2-54-161-87-5.compute-1.amazonaws.com:8080';
  static const BASE_URL_PROD = 'http://200.133.6.201:30001/';
  static const BASE_URL_DEV = 'http://191.101.78.251:3010/';

  //-> AUTHENTICATION
  /// Route to '/auth'
  static const _REQUEST_AUTH = '/auth';

  /// Route to '/auth/login'
  static const REQUEST_LOGIN = '$_REQUEST_AUTH/login';

  /// Route to '/auth/send-recover-email'
  static const REQUEST_RECOVER_EMAIL = '$_REQUEST_AUTH/send-recover-email';

  /// Route to '/auth/send-recover-email/$token'
  static String REQUEST_RESET_PASSWORD(String token) =>
      '$REQUEST_RECOVER_EMAIL/$token';

  //-> USER
  /// Route to '/users'
  static const REQUEST_USERS = '/users';

  /// Route to '/users/$id'
  static String REQUEST_USERS_WITH_ID(String id) => '$REQUEST_USERS/$id';

  //-> ENZYMES
  /// Route to '/enzymes'
  static const REQUEST_ENZYMES = '/enzymes';

  /// Route to '/enzymes/$id'
  static String REQUEST_ENZYMES_WITH_ID(String id) => '$REQUEST_ENZYMES/$id';

  //-> TREATMENTS
  /// Route to '/processes'
  static const REQUEST_TREATMENTS = '/processes';

  /// Route to '/processes/$id'
  static String REQUEST_TREATMENTS_WITH_ID(String id) =>
      '$REQUEST_TREATMENTS/$id';

  //-> EXPERIMENTS
  /// Route to '/experiments'
  static const REQUEST_EXPERIMENTS = '/experiments';

  /// Route to '/experiments/$id'
  static String REQUEST_EXPERIMENTS_WITH_ID(String id) =>
      '$REQUEST_EXPERIMENTS/$id';

  /// Route to '/experiments/calculate/$experiment'
  static String REQUEST_CALCULATE_EXPERIMENTS(String experiment) =>
      '$REQUEST_EXPERIMENTS/calculate/$experiment';

  /// Route to '/experiments/save-result/$experiment'
  static String REQUEST_SAVE_RESULT_EXPERIMENTS(String experiment) =>
      '$REQUEST_EXPERIMENTS/save-result/$experiment';

  /// Route to '/experiments/save-result/$experiment'
  static String REQUEST_GET_RESULT_EXPERIMENTS(String experiment) =>
      '$REQUEST_EXPERIMENTS/get-total-result/$experiment';

  /// Route to '/experiments/get-total-result/$experiment'
  static String REQUEST_TOTAL_RESULTS_OF_EXPERIMENT(String experiment) =>
      '$REQUEST_EXPERIMENTS/get-total-result/$experiment';

  /// Route to '/experiments/get-enzymes/$experiment'
  static String REQUEST_ENZYMES_REMAINING_IN_EXPERIMENT(String experiment) =>
      '$REQUEST_EXPERIMENTS/get-enzymes/$experiment';
}
