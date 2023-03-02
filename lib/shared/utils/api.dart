// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class API {
  //-> SETUP
  static const BASE_URL = 'http://3.86.26.20:8080';

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
}
