// ignore_for_file: constant_identifier_names, non_constant_identifier_names

class API {
  static const BASE_URL = 'http://3.86.26.20:8080';

  static const _REQUEST_AUTH = '/auth';

  static const REQUEST_LOGIN = '$_REQUEST_AUTH/login';
  static const REQUEST_RECOVER_EMAIL = '$_REQUEST_AUTH/send-recover-email';
  static String REQUEST_RESET_PASSWORD(String token) =>
      '$REQUEST_RECOVER_EMAIL/$token';

  static const REQUEST_USERS = '/users';
  static REQUEST_USERS_WITH_ID(String id) => '$REQUEST_USERS/$id';

  static const REQUEST_ENZYMES = '/enzymes';
  static REQUEST_ENZYMES_WITH_ID(String id) => '$REQUEST_ENZYMES/$id';

  static const REQUEST_TREATMENTS = '/processes';
  static REQUEST_TREATMENTS_WITH_ID(String id) => '$REQUEST_TREATMENTS/$id';

  static const REQUEST_EXPERIMENTS = '/experiments';
  static REQUEST_EXPERIMENTS_WITH_ID(String id) => '$REQUEST_EXPERIMENTS/$id';

  static REQUEST_CALCULATE_EXPERIMENTS(String experiment) =>
      '$REQUEST_EXPERIMENTS/calculate/$experiment';
  static REQUEST_SAVE_RESULT_EXPERIMENTS(String experiment) =>
      '$REQUEST_EXPERIMENTS/save-result/$experiment';
}
