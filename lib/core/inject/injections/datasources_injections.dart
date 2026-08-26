// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/data/datasources/auth_datasource.dart';
import '../../../features/authentication/data/datasources/remote/auth_remote_datasource_imp.dart';
import '../../../features/enzyme/data/datasources/enzymes_datasource.dart';
import '../../../features/enzyme/data/datasources/local/enzymes_local_datasource_decorator_imp.dart';
import '../../../features/enzyme/data/datasources/remote/enzymes_remote_datasource_imp.dart';
import '../../../features/experiment/data/datasources/experiments_datasource.dart';
import '../../../features/experiment/data/datasources/local/experiments_local_datasource_decorator_imp.dart';
import '../../../features/experiment/data/datasources/remote/experiments_remote_datasource_imp.dart';
import '../../../features/main/data/datasources/local/user_preferences_local_datasource_imp.dart';
import '../../../features/main/data/datasources/user_preferences_datasource.dart';
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

    getIt.registerLazySingleton<UserPreferencesDataSource>(
      () => UserPreferencesLocalDataSourceImp(getIt(), getIt()),
    );

    getIt.registerLazySingleton<AuthDataSource>(
      () => AuthRemoteDataSourceImp(getIt(), getIt(), getIt()),
    );
  }
}
