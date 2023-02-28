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
import '../../features/main/data/datasources/clear_user_datasource.dart';
import '../../features/main/data/datasources/get_enzymes_datasource.dart';
import '../../features/main/data/datasources/get_exclude_confirmation_datasource.dart';
import '../../features/main/data/datasources/get_experiments_datasource.dart';
import '../../features/main/data/datasources/get_treatments_datasource.dart';
import '../../features/main/data/datasources/get_user_datasource.dart';
import '../../features/main/data/datasources/local/clear_user/clear_user_local_datasource_imp.dart';
import '../../features/main/data/datasources/local/get_enzymes/get_enzymes_local_datasource_decorator_imp.dart';
import '../../features/main/data/datasources/local/get_exclude_confirmation/get_exclude_confirmation_local_datasource_imp.dart';
import '../../features/main/data/datasources/local/get_experiments/get_experiments_local_datasource_decorator_imp.dart';
import '../../features/main/data/datasources/local/get_treatments/get_treatments_local_datasource_decorator_imp.dart';
import '../../features/main/data/datasources/local/get_user/get_user_local_datasource_imp.dart';
import '../../features/main/data/datasources/local/save_exclude_confirmation/save_exclude_confirmation_local_datasource_imp.dart';
import '../../features/main/data/datasources/remote/get_enzymes_remote_datasource_imp.dart';
import '../../features/main/data/datasources/remote/get_experiments_remote_datasource_imp.dart';
import '../../features/main/data/datasources/remote/get_treatments_remote_datasource_imp.dart';
import '../../features/main/data/datasources/save_exclude_confirmation_datasource.dart';
import '../../features/main/data/repositories/clear_user_repository_imp.dart';
import '../../features/main/data/repositories/get_enzymes_repository_imp.dart';
import '../../features/main/data/repositories/get_exclude_confirmation_repository_imp.dart';
import '../../features/main/data/repositories/get_experiments_repository_imp.dart';
import '../../features/main/data/repositories/get_treatments_repository_imp.dart';
import '../../features/main/data/repositories/get_user_repository_imp.dart';
import '../../features/main/data/repositories/save_exclude_confirmation_repository_imp.dart';
import '../../features/main/data/repositories/store_experiments_in_cache_repository_imp.dart';
import '../../features/main/domain/repositories/clear_user_repository.dart';
import '../../features/main/domain/repositories/get_enzymes_repository.dart';
import '../../features/main/domain/repositories/get_exclude_confirmation_repository.dart';
import '../../features/main/domain/repositories/get_experiments_repository.dart';
import '../../features/main/domain/repositories/get_treatments_repository.dart';
import '../../features/main/domain/repositories/get_user_repository.dart';
import '../../features/main/domain/repositories/save_exclude_confirmation_repository.dart';
import '../../features/main/domain/repositories/store_experiments_in_cache_repository.dart';
import '../../features/main/domain/usecases/clear_user/clear_user_usecase.dart';
import '../../features/main/domain/usecases/clear_user/clear_user_usecase_imp.dart';
import '../../features/main/domain/usecases/get_enzymes/get_enzymes_usecase.dart';
import '../../features/main/domain/usecases/get_enzymes/get_enzymes_usecase_imp.dart';
import '../../features/main/domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase.dart';
import '../../features/main/domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase_imp.dart';
import '../../features/main/domain/usecases/get_experiments/get_experiments_usecase.dart';
import '../../features/main/domain/usecases/get_experiments/get_experiments_usecase_imp.dart';
import '../../features/main/domain/usecases/get_treatments/get_treatments_usecase.dart';
import '../../features/main/domain/usecases/get_treatments/get_treatments_usecase_imp.dart';
import '../../features/main/domain/usecases/get_user/get_user_usecase.dart';
import '../../features/main/domain/usecases/get_user/get_user_usecase_imp.dart';
import '../../features/main/domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase.dart';
import '../../features/main/domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase_imp.dart';
import '../../features/main/domain/usecases/store_experiments_in_cache/store_experiments_in_cache_usecase.dart';
import '../../features/main/domain/usecases/store_experiments_in_cache/store_experiments_in_cache_usecase_imp.dart';
import '../../features/main/presentation/viewmodel/fragments/account_viewmodel.dart';
import '../../features/main/presentation/viewmodel/fragments/enzymes_viewmodel.dart';
import '../../features/main/presentation/viewmodel/fragments/experiments_viewmodel.dart';
import '../../features/main/presentation/viewmodel/fragments/treatments_viewmodel.dart';
import '../../features/main/presentation/viewmodel/home_viewmodel.dart';
import '../../features/main/presentation/viewmodel/splash_viewmodel.dart';
import '../data/service/connection_checker/connection_checker_imp.dart';
import '../data/service/http/http_service_imp.dart';
import '../data/service/key_value/key_value_service_imp.dart';
import '../data/service/user_preferences/user_preferences_service_imp.dart';
import '../domain/entities/http_driver_options.dart';
import '../domain/service/connection_checker/connection_checker.dart';
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
    getIt.registerLazySingleton<KeyValueService>(
      () => SharedPrefsServiceImp(),
    );
    getIt.registerLazySingleton<UserPreferencesServices>(
      () => UserPreferencesServicesImp(getIt()),
    );
    getIt.registerLazySingleton<ConnectionChecker>(
      () => ConnectionCheckerImp(),
    );

    //* DataSources
    getIt.registerLazySingleton<LoginDataSource>(
      () => LoginRemoteDataSourceImp(getIt(), getIt()),
    );
    getIt.registerLazySingleton<ClearUserDataSource>(
      () => ClearUserLocalDataSourceImp(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GetEnzymesDataSource>(
      () => GetEnzymesDataSourceDecoratorImp(
        GetEnzymesRemoteDataSourceImp(getIt()),
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GetExcludeConfirmationDataSource>(
      () => GetExcludeConfirmationLocalDataSourceImp(
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GetExperimentsDataSource>(
      () => GetExperimentsDataSourceDecoratorImp(
        GetExperimentsRemoteDataSourceImp(getIt()),
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GetTreatmentsDataSource>(
      () => GetTreatmentsDataSourceDecoratorImp(
        GetTreatmentsRemoteDataSourceImp(getIt()),
        getIt(),
      ),
    );
    getIt.registerLazySingleton<GetUserDataSource>(
      () => GetUserLocalDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<SaveExcludeConfirmationDataSource>(
      () => SaveExcludeConfirmationLocalDataSourceImp(getIt()),
    );

    //* Repositories
    getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<ClearUserRepository>(
      () => ClearUserRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetEnzymesRepository>(
      () => GetEnzymesRepositoryImp(getIt()),
    );

    getIt.registerLazySingleton<GetExcludeConfirmationRepository>(
      () => GetExcludeConfirmationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetExperimentsRepository>(
      () => GetExperimentsRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetTreatmentsRepository>(
      () => GetTreatmentsRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetUserRepository>(
      () => GetUserRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<SaveExcludeConfirmationRepository>(
      () => SaveExcludeConfirmationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<StoreExperimentsInCacheRepository>(
      () => StoreExperimentsInCacheRepositoryImp(getIt()),
    );

    //* UseCases
    getIt.registerLazySingleton<LoginUseCase>(
      () => LoginUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<ClearUserUseCase>(
      () => ClearUserUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<GetEnzymesUseCase>(
      () => GetEnzymesUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<GetExcludeConfirmationUseCase>(
      () => GetExcludeConfirmationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<GetExperimentsUseCase>(
      () => GetExperimentsUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<GetTreatmentsUseCase>(
      () => GetTreatmentsUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<GetUserUseCase>(
      () => GetUserUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<SaveExcludeConfirmationUseCase>(
      () => SaveExcludeConfirmationUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<StoreExperimentsInCacheUseCase>(
      () => StoreExperimentsInCacheUseCaseImp(getIt()),
    );

    //* Viewmodels
    getIt.registerFactory<LoginViewmodel>(
      () => LoginViewmodel(getIt()),
    );
    getIt.registerFactory<SplashViewmodel>(
      () => SplashViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<HomeViewmodel>(
      () => HomeViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<ExperimentsViewmodel>(
      () => ExperimentsViewmodel(getIt(), getIt()),
    );
    getIt.registerLazySingleton<TreatmentsViewmodel>(
      () => TreatmentsViewmodel(getIt()),
    );
    getIt.registerLazySingleton<EnzymesViewmodel>(
      () => EnzymesViewmodel(getIt()),
    );
    getIt.registerLazySingleton<AccountViewmodel>(
      () => AccountViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
  }
}
