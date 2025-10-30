// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/data/datasources/create_account_datasource.dart';
import '../../../features/authentication/data/datasources/login_datasource.dart';
import '../../../features/authentication/data/datasources/remote/create_account_remote_datasource_imp.dart';
import '../../../features/authentication/data/datasources/remote/login_remote_datasource_imp.dart';
import '../../../features/enzyme/data/datasources/enzymes_datasource.dart';
import '../../../features/enzyme/data/datasources/local/enzymes_local_datasource_decorator_imp.dart';
import '../../../features/enzyme/data/datasources/remote/enzymes_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/experiments_datasource.dart';
import '../../../features/experiment/data/datasources/local/experiments_local_datasource_decorator_imp.dart';
import '../../../features/experiment/data/datasources/remote/experiments_remote_datasource_imp.dart';
import '../../../features/main/data/datasources/clear_user_datasource.dart';
import '../../../features/main/data/datasources/get_exclude_confirmation_datasource.dart';
import '../../../features/main/data/datasources/get_replace_language_datasource.dart';
import '../../../features/main/data/datasources/get_theme_mode_datasource.dart';
import '../../../features/main/data/datasources/get_user_datasource.dart';
import '../../../features/main/data/datasources/local/clear_user/clear_user_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/clear_user/get_user_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/get_exclude_confirmation/get_exclude_confirmation_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/get_replace_language/get_replace_language_datasource_imp.dart';
import '../../../features/main/data/datasources/local/get_theme_mode/get_theme_mode_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/save_exclude_confirmation/save_exclude_confirmation_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/save_replace_language/save_replace_language_datasource_imp.dart';
import '../../../features/main/data/datasources/local/save_theme_mode/save_theme_mode_local_datasource_imp.dart';
import '../../../features/main/data/datasources/save_exclude_confirmation_datasource.dart';
import '../../../features/main/data/datasources/save_replace_language_datasource.dart';
import '../../../features/main/data/datasources/save_theme_mode_datasource.dart';
import '../../../features/treatment/data/datasources/local/treatments_local_datasource_decorator_imp.dart';
import '../../../features/treatment/data/datasources/remote/treatments_remote_datasource_imp.dart';
import '../../../features/treatment/data/datasources/treatments_datasource.dart';

class DataSourcesInjections {
  final GetIt getIt;

  DataSourcesInjections(this.getIt) {
    getIt.registerLazySingleton<EnzymesDataSource>(
      () => EnzymesDataSourceDecoratorImp(EnzymesRemoteDataSourceImp(getIt()), getIt()),
    );

    getIt.registerLazySingleton<TreatmentsDataSource>(
      () => TreatmentsDataSourceDecoratorImp(TreatmentsRemoteDataSourceImp(getIt()), getIt()),
    );

    getIt.registerLazySingleton<ExperimentsDataSource>(
      () => ExperimentsDataSourceDecoratorImp(ExperimentsRemoteDataSourceImp(getIt()), getIt()),
    );

    getIt.registerLazySingleton<ClearUserDataSource>(() => ClearUserLocalDataSourceImp(getIt()));
    getIt.registerLazySingleton<CreateAccountDataSource>(() => CreateAccountRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetExcludeConfirmationDataSource>(
      () => GetExcludeConfirmationLocalDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<GetThemeModeDataSource>(() => GetThemeModeLocalDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetReplaceLanguageDataSource>(() => GetReplaceLanguageDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetUserDataSource>(() => GetUserLocalDataSourceImp(getIt()));
    getIt.registerLazySingleton<LoginDataSource>(() => LoginRemoteDataSourceImp(getIt(), getIt()));
    getIt.registerLazySingleton<SaveExcludeConfirmationDataSource>(
      () => SaveExcludeConfirmationLocalDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<SaveReplaceLanguageDataSource>(() => SaveReplaceLanguageDataSourceImp(getIt()));
    getIt.registerLazySingleton<SaveThemeModeDataSource>(() => SaveThemeModeLocalDataSourceImp(getIt()));
  }
}
