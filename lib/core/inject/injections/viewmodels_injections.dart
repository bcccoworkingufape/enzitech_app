import 'package:get_it/get_it.dart';

import '../../../features/authentication/presentation/viewmodel/create_account_viewmodel.dart';
import '../../../features/authentication/presentation/viewmodel/login_viewmodel.dart';
import '../../../features/enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../features/experiment/presentation/viewmodel/experiments_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/account_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/home_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/splash_viewmodel.dart';
import '../../../features/treatment/presentation/viewmodel/treatments_viewmodel.dart';

class ViewmodelsInjections {
  final GetIt getIt;

  ViewmodelsInjections(this.getIt) {
    getIt.registerLazySingleton<CreateAccountViewmodel>(
      () => CreateAccountViewmodel(getIt()),
    );
    getIt.registerLazySingleton<LoginViewmodel>(
      () => LoginViewmodel(getIt()),
    );
    getIt.registerFactory<SplashViewmodel>(
      () => SplashViewmodel(getIt(), getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<HomeViewmodel>(
      () => HomeViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<ExperimentsViewmodel>(
      () => ExperimentsViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<TreatmentsViewmodel>(
      () => TreatmentsViewmodel(getIt(), getIt()),
    );
    getIt.registerLazySingleton<EnzymesViewmodel>(
      () => EnzymesViewmodel(getIt(), getIt()),
    );
    getIt.registerLazySingleton<AccountViewmodel>(
      () => AccountViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
  }
}
