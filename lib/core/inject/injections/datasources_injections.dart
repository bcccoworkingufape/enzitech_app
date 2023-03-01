import 'package:get_it/get_it.dart';

import '../../../features/authentication/data/datasources/create_account_datasource.dart';
import '../../../features/authentication/data/datasources/login_datasource.dart';
import '../../../features/authentication/data/datasources/remote/create_account_remote_datasource_imp.dart';
import '../../../features/authentication/data/datasources/remote/login_remote_datasource_imp.dart';
import '../../../features/enzyme/data/datasources/delete_enzyme_datasource.dart';
import '../../../features/enzyme/data/datasources/get_enzymes_datasource.dart';
import '../../../features/enzyme/data/datasources/local/get_enzymes/get_enzymes_local_datasource_decorator_imp.dart';
import '../../../features/enzyme/data/datasources/remote/delete_enzyme_remote_datasource_imp.dart';
import '../../../features/enzyme/data/datasources/remote/get_enzymes_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/delete_experiment_datasource.dart';
import '../../../features/experiment/data/datasources/get_experiments_datasource.dart';
import '../../../features/experiment/data/datasources/local/get_experiments/get_experiments_local_datasource_decorator_imp.dart';
import '../../../features/experiment/data/datasources/remote/delete_experiment_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/remote/get_experiments_remote_datasource_imp.dart';
import '../../../features/main/data/datasources/clear_user_datasource.dart';
import '../../../features/main/data/datasources/get_exclude_confirmation_datasource.dart';
import '../../../features/main/data/datasources/get_user_datasource.dart';
import '../../../features/main/data/datasources/local/clear_user/clear_user_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/clear_user/get_user_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/get_exclude_confirmation/get_exclude_confirmation_local_datasource_imp.dart';
import '../../../features/main/data/datasources/local/save_exclude_confirmation/save_exclude_confirmation_local_datasource_imp.dart';
import '../../../features/main/data/datasources/save_exclude_confirmation_datasource.dart';
import '../../../features/treatment/data/datasources/delete_treatment_datasource.dart';
import '../../../features/treatment/data/datasources/get_treatments_datasource.dart';
import '../../../features/treatment/data/datasources/local/get_treatments/get_treatments_local_datasource_decorator_imp.dart';
import '../../../features/treatment/data/datasources/remote/delete_treatment_remote_datasource_imp.dart';
import '../../../features/treatment/data/datasources/remote/get_treatments_remote_datasource_imp.dart';

class DataSourcesInjections {
  final GetIt getIt;

  DataSourcesInjections(this.getIt) {
    getIt.registerLazySingleton<DeleteEnzymeDataSource>(
      () => DeleteEnzymeRemoteDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteTreatmentDataSource>(
      () => DeleteTreatmentRemoteDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteExperimentDataSource>(
      () => DeleteExperimentRemoteDataSourceImp(getIt()),
    );
    getIt.registerLazySingleton<CreateAccountDataSource>(
      () => CreateAccountRemoteDataSourceImp(getIt()),
    );
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
  }
}
