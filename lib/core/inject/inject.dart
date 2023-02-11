// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../features/authentication/data/datasources/login_datasource.dart';
import '../../features/authentication/data/datasources/remote/login_remote_datasource_imp.dart';
import '../../features/authentication/data/repositories/login_repository_imp.dart';
import '../../features/authentication/domain/repositories/login_repository.dart';
import '../../features/authentication/domain/usecases/login/login_usecase.dart';
import '../../features/authentication/domain/usecases/login/login_usecase_imp.dart';
import '../../features/authentication/presentation/viewmodel/login_viewmodel.dart';
import '../../features/main/data/datasources/get_enzymes_datasource.dart';
import '../../features/main/data/datasources/local/get_enzymes_local_datasource_decorator_imp.dart';
import '../../features/main/data/datasources/remote/get_enzymes_remote_datasource_imp.dart';
import '../../features/main/data/repositories/get_enzymes_repository_imp.dart';
import '../../features/main/domain/repositories/get_enzymes_repository.dart';
import '../../features/main/domain/usecases/get_enzymes/get_enzymes_usecase.dart';
import '../../features/main/domain/usecases/get_enzymes/get_enzymes_usecase_imp.dart';
import '../../features/main/presentation/viewmodel/splash_viewmodel.dart';
import '../data/service/http/http_service_imp.dart';
import '../data/service/key_value/key_value_service_imp.dart';
import '../data/service/user_preferences/user_preferences_service_imp.dart';
import '../domain/entities/http_driver_options.dart';
import '../domain/service/http/http_service.dart';
import '../domain/service/key_value/key_value_service.dart';
import '../domain/service/user_preferences/user_preferences_service.dart';

GetIt getIt = GetIt.instance;

class Inject {
  //-> HttpDriverOptions is required to reset Dio's token options
  static initialize(HttpDriverOptions httpDriverOptions) {
    //* Core
    getIt.registerLazySingleton<HttpService>(
      () => DioHttpServiceImp(httpDriverOptions),
    );
    getIt.registerLazySingleton<KeyValueService>(() => SharedPrefsServiceImp());
    getIt.registerLazySingleton<UserPreferencesServices>(
        () => UserPreferencesServicesImp(getIt()));

    //* DataSources
    getIt.registerLazySingleton<LoginDataSource>(
      () => LoginRemoteDataSourceImp(
        getIt(),
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GetEnzymesDataSource>(
      () => GetEnzymesDataSourceDecoratorImp(
        GetEnzymesRemoteDataSourceImp(
          getIt(),
        ),
        getIt(),
      ),
    );
    /* getIt.registerLazySingleton<GetEnzymesDataSource>(
      () => GetEnzymesRemoteDataSource(getIt()),
    ); */

    //* Repositories
    getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetEnzymesRepository>(
      () => GetEnzymesRepositoryImp(getIt()),
    );

    //* UseCases
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<GetEnzymesUseCase>(
      () => GetEnzymesUseCaseImp(getIt()),
    );

    //* Viewmodels
    getIt.registerLazySingleton<LoginViewmodel>(
      () => LoginViewmodel(getIt()),
    );
    getIt.registerFactory<SplashViewmodel>(
      () => SplashViewmodel(getIt()),
    );
  }
}
