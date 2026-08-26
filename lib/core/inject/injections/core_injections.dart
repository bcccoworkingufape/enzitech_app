// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../data/service/connection_checker/connection_checker_imp.dart';
import '../../data/service/http/http_service_imp.dart';
import '../../data/service/key_value/key_value_service_imp.dart';
import '../../data/service/platform_service/platform_service_imp.dart';
import '../../data/service/secure_storage/secure_session_storage.dart';
import '../../data/service/user_preferences/user_preferences_service_imp.dart';
import '../../domain/entities/http_driver_options.dart';
import '../../domain/service/connection_checker/connection_checker.dart';
import '../../domain/service/http/http_service.dart';
import '../../domain/service/key_value/key_value_service.dart';
import '../../domain/service/platform_service/platform_service.dart';
import '../../domain/service/user_preferences/user_preferences_service.dart';

class CoreInjections {
  final HttpDriverOptions httpDriverOptions;
  final GetIt getIt;

  CoreInjections(this.httpDriverOptions, this.getIt) {
    getIt.registerLazySingleton<ConnectionChecker>(() => ConnectionCheckerImp());
    getIt.registerLazySingleton<HttpService>(() => DioHttpServiceImp(httpDriverOptions));
    getIt.registerLazySingleton<KeyValueService>(() => SharedPrefsServiceImp());
    getIt.registerLazySingleton<PlatformService>(() => PlatformServiceImp());
    // Os segredos da sessão ficam em EncryptedSharedPreferences/Keychain.
    getIt.registerLazySingleton<SecureSessionStorage>(() => SecureSessionStorage());
    getIt.registerLazySingleton<UserPreferencesService>(() => UserPreferencesServiceImp(getIt()));
  }
}
