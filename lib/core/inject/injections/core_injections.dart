import 'package:get_it/get_it.dart';

import '../../data/service/connection_checker/connection_checker_imp.dart';
import '../../data/service/http/http_service_imp.dart';
import '../../data/service/key_value/key_value_service_imp.dart';
import '../../data/service/user_preferences/user_preferences_service_imp.dart';
import '../../domain/entities/http_driver_options.dart';
import '../../domain/service/connection_checker/connection_checker.dart';
import '../../domain/service/http/http_service.dart';
import '../../domain/service/key_value/key_value_service.dart';
import '../../domain/service/user_preferences/user_preferences_service.dart';

class CoreInjections {
  final HttpDriverOptions httpDriverOptions;
  final GetIt getIt;

  CoreInjections(this.httpDriverOptions, this.getIt) {
    getIt.registerLazySingleton<HttpService>(
      () => DioHttpServiceImp(httpDriverOptions),
    );
    getIt.registerLazySingleton<KeyValueService>(
      () => SharedPrefsServiceImp(),
    );
    getIt.registerLazySingleton<UserPreferencesServices>(
      () => UserPreferencesServicesImp(getIt()),
    );
    getIt.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImp(),
    );
  }
}
