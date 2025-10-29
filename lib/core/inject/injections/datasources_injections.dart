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
import '../../../features/experiment/data/datasources/calculate_experiment_datasource.dart';
import '../../../features/experiment/data/datasources/create_experiment_datasource.dart';
import '../../../features/experiment/data/datasources/delete_experiment_datasource.dart';
import '../../../features/experiment/data/datasources/get_enzymes_remaining_in_experiment_datasource.dart';
import '../../../features/experiment/data/datasources/get_experiment_by_id_datasource.dart';
import '../../../features/experiment/data/datasources/get_experiments_datasource.dart';
import '../../../features/experiment/data/datasources/get_result_datasource.dart';
import '../../../features/experiment/data/datasources/local/get_experiments/get_experiments_local_datasource_decorator_imp.dart';
import '../../../features/experiment/data/datasources/remote/calculate_experiment_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/create_experiment_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/delete_experiment_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/get_enzymes_remaining_in_experiment_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/get_experiment_by_id_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/get_experiments_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/get_result_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/save_result_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/save_result_datasource.dart';
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
import '../../../features/treatment/data/datasources/create_treatment_datasource.dart';
import '../../../features/treatment/data/datasources/delete_treatment_datasource.dart';
import '../../../features/treatment/data/datasources/get_treatments_datasource.dart';
import '../../../features/treatment/data/datasources/local/get_treatments/get_treatments_local_datasource_decorator_imp.dart';
import '../../../features/treatment/data/datasources/remote/create_treatment_remote_datasource_imp.dart';
import '../../../features/treatment/data/datasources/remote/delete_treatment_remote_datasource_imp.dart';
import '../../../features/treatment/data/datasources/remote/get_treatments_remote_datasource_imp.dart';

class DataSourcesInjections {
  final GetIt getIt;

  DataSourcesInjections(this.getIt) {
    getIt.registerLazySingleton<EnzymesDataSource>(
      () => EnzymesDataSourceDecoratorImp(EnzymesRemoteDataSourceImp(getIt()), getIt()),
    );

    getIt.registerLazySingleton<CalculateExperimentDataSource>(() => CalculateExperimentRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<ClearUserDataSource>(() => ClearUserLocalDataSourceImp(getIt()));
    getIt.registerLazySingleton<CreateAccountDataSource>(() => CreateAccountRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<CreateExperimentDataSource>(() => CreateExperimentRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<CreateTreatmentDataSource>(() => CreateTreatmentRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<DeleteTreatmentDataSource>(() => DeleteTreatmentRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<DeleteExperimentDataSource>(() => DeleteExperimentRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetEnzymesRemainingInExperimentDataSource>(
      () => GetEnzymesRemainingInExperimentRemoteDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<GetExcludeConfirmationDataSource>(
      () => GetExcludeConfirmationLocalDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<GetExperimentByIdDataSource>(() => GetExperimentByIdRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetExperimentsDataSource>(
      () => GetExperimentsDataSourceDecoratorImp(GetExperimentsRemoteDataSourceImp(getIt()), getIt()),
    );
    getIt.registerLazySingleton<GetResultDataSource>(() => GetResultRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetThemeModeDataSource>(() => GetThemeModeLocalDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetReplaceLanguageDataSource>(() => GetReplaceLanguageDataSourceImp(getIt()));
    getIt.registerLazySingleton<GetTreatmentsDataSource>(
      () => GetTreatmentsDataSourceDecoratorImp(GetTreatmentsRemoteDataSourceImp(getIt()), getIt()),
    );
    getIt.registerLazySingleton<GetUserDataSource>(() => GetUserLocalDataSourceImp(getIt()));
    getIt.registerLazySingleton<LoginDataSource>(() => LoginRemoteDataSourceImp(getIt(), getIt()));
    getIt.registerLazySingleton<SaveExcludeConfirmationDataSource>(
      () => SaveExcludeConfirmationLocalDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<SaveReplaceLanguageDataSource>(() => SaveReplaceLanguageDataSourceImp(getIt()));
    getIt.registerLazySingleton<SaveResultDataSource>(() => SaveResultRemoteDataSourceImp(getIt()));
    getIt.registerLazySingleton<SaveThemeModeDataSource>(() => SaveThemeModeLocalDataSourceImp(getIt()));
  }
}
