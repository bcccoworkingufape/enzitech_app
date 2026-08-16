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

  //-> SETUP
  //STAGING SERVER
  static Map<String, dynamic> stageConstants = {_baseUrl: "https://enzitech.api.bcccoworking.org"};
  
  //LOCALHOST
  static Map<String, dynamic> devConstants = {_baseUrl: "http://10.0.2.2:8080"};

  static Map<String, dynamic> prodConstants = {_baseUrl: "http://200.133.6.201:30001/"};

  //-> AUTHENTICATION
  static const _REQUEST_AUTH = '/auth';
  static const REQUEST_LOGIN = '$_REQUEST_AUTH/login';
  static const REQUEST_RECOVER_EMAIL = '$_REQUEST_AUTH/forgot-password';
  static const REQUEST_VERIFY_PIN = '$_REQUEST_AUTH/verify-pin';
  static const REQUEST_RESET_PASSWORD = '$_REQUEST_AUTH/reset-password';

  //-> USER
  static const REQUEST_USERS = '/users';
  static String REQUEST_USERS_WITH_ID(String id) => '$REQUEST_USERS/$id';

  //-> ENZYMES
  static const REQUEST_ENZYMES = '/enzymes';
  static String REQUEST_ENZYMES_WITH_ID(String id) => '$REQUEST_ENZYMES/$id';

  //-> TREATMENTS
  static const REQUEST_TREATMENTS = '/treatments';
  static const REQUEST_TREATMENTS_USER ='$_REQUEST_AUTH/user';
  static String REQUEST_TREATMENTS_WITH_ID(String id) => '$REQUEST_TREATMENTS/$id';
  static String REQUEST_TREATMENTS_BY_EXPERIMENT(String experimentId) => '$REQUEST_TREATMENTS/experiment/$experimentId';

  //-> EXPERIMENTS
  static const REQUEST_EXPERIMENTS = '/experiments';
  static String REQUEST_EXPERIMENTS_WITH_ID(String id) => '$REQUEST_EXPERIMENTS/$id';
  static String REQUEST_REPETITIONS(String experiment) => '$REQUEST_EXPERIMENTS/$experiment/repetitions';
  static String REQUEST_PREVIEW_REPETITION(String experiment) => '$REQUEST_EXPERIMENTS/$experiment/repetitions/preview';
  static String REQUEST_GET_RESULT_EXPERIMENTS(String experiment) => '$REQUEST_EXPERIMENTS/get-total-result/$experiment';
  static String REQUEST_TOTAL_RESULTS_OF_EXPERIMENT(String experiment) => '$REQUEST_EXPERIMENTS/get-total-result/$experiment';
}