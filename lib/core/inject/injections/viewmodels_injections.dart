// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/presentation/viewmodel/create_account_viewmodel.dart';
import '../../../features/authentication/presentation/viewmodel/login_viewmodel.dart';
import '../../../features/enzyme/presentation/viewmodel/create_enzyme_viewmodel.dart';
import '../../../features/enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../features/experiment/presentation/viewmodel/calculate_experiment_viewmodel.dart';
import '../../../features/experiment/presentation/viewmodel/create_experiment_viewmodel.dart';
import '../../../features/experiment/presentation/viewmodel/experiment_details_viewmodel.dart';
import '../../../features/experiment/presentation/viewmodel/experiment_results_viewmodel.dart';
import '../../../features/experiment/presentation/viewmodel/experiments_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/settings_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/home_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/splash_viewmodel.dart';
import '../../../features/treatment/presentation/viewmodel/create_treatment_viewmodel.dart';
import '../../../features/treatment/presentation/viewmodel/treatments_viewmodel.dart';

class ViewmodelsInjections {
  final GetIt getIt;

  ViewmodelsInjections(this.getIt) {
    getIt.registerLazySingleton<SettingsViewmodel>(
      () => SettingsViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<CalculateExperimentViewmodel>(
      () => CalculateExperimentViewmodel(getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<CreateAccountViewmodel>(
      () => CreateAccountViewmodel(getIt()),
    );
    getIt.registerLazySingleton<CreateEnzymeViewmodel>(
      () => CreateEnzymeViewmodel(getIt()),
    );
    getIt.registerLazySingleton<CreateExperimentViewmodel>(
      () => CreateExperimentViewmodel(getIt()),
    );
    getIt.registerLazySingleton<CreateTreatmentViewmodel>(
      () => CreateTreatmentViewmodel(getIt()),
    );
    getIt.registerLazySingleton<EnzymesViewmodel>(
      () => EnzymesViewmodel(getIt(), getIt()),
    );
    getIt.registerLazySingleton<ExperimentDetailsViewmodel>(
      () => ExperimentDetailsViewmodel(getIt()),
    );
    getIt.registerLazySingleton<ExperimentResultsViewmodel>(
      () => ExperimentResultsViewmodel(getIt()),
    );
    getIt.registerLazySingleton<ExperimentsViewmodel>(
      () => ExperimentsViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<HomeViewmodel>(
      () => HomeViewmodel(getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<LoginViewmodel>(
      () => LoginViewmodel(getIt()),
    );
    getIt.registerFactory<SplashViewmodel>(
      () => SplashViewmodel(getIt(), getIt(), getIt(), getIt(), getIt()),
    );
    getIt.registerLazySingleton<TreatmentsViewmodel>(
      () => TreatmentsViewmodel(getIt(), getIt()),
    );
  }
}
