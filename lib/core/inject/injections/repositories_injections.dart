// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/data/repositories/create_account_repository_imp.dart';
import '../../../features/authentication/data/repositories/login_repository_imp.dart';
import '../../../features/authentication/domain/repositories/create_account_repository.dart';
import '../../../features/authentication/domain/repositories/login_repository.dart';
import '../../../features/enzyme/data/repositories/create_enzyme_repository_imp.dart';
import '../../../features/enzyme/data/repositories/delete_enzyme_repository_imp.dart';
import '../../../features/enzyme/data/repositories/get_enzymes_repository_imp.dart';
import '../../../features/enzyme/domain/repositories/create_enzyme_repository.dart';
import '../../../features/enzyme/domain/repositories/delete_enzyme_repository.dart';
import '../../../features/enzyme/domain/repositories/get_enzymes_repository.dart';
import '../../../features/experiment/data/repositories/calculate_experiment_repository_imp.dart';
import '../../../features/experiment/data/repositories/create_experiment_repository_imp.dart';
import '../../../features/experiment/data/repositories/delete_experiment_repository_imp.dart';
import '../../../features/experiment/data/repositories/get_enzymes_remaining_in_experiment_repository_imp.dart';
import '../../../features/experiment/data/repositories/get_experiment_by_id_repository_imp.dart';
import '../../../features/experiment/data/repositories/get_experiments_repository_imp.dart';
import '../../../features/experiment/data/repositories/get_result_repository_imp.dart';
import '../../../features/experiment/data/repositories/save_result_repository_imp.dart';
import '../../../features/experiment/data/repositories/store_experiments_in_cache_repository_imp.dart';
import '../../../features/experiment/domain/repositories/calculate_experiment_repository.dart';
import '../../../features/experiment/domain/repositories/create_experiment_repository.dart';
import '../../../features/experiment/domain/repositories/delete_experiment_repository.dart';
import '../../../features/experiment/domain/repositories/get_enzymes_remaining_in_experiment_repository.dart';
import '../../../features/experiment/domain/repositories/get_experiment_by_id_repository.dart';
import '../../../features/experiment/domain/repositories/get_experiments_repository.dart';
import '../../../features/experiment/domain/repositories/get_result_repository.dart';
import '../../../features/experiment/domain/repositories/save_result_repository.dart';
import '../../../features/experiment/domain/repositories/store_experiments_in_cache_repository.dart';
import '../../../features/main/data/repositories/clear_user_repository_imp.dart';
import '../../../features/main/data/repositories/get_exclude_confirmation_repository_imp.dart';
import '../../../features/main/data/repositories/get_theme_mode_repository_imp.dart';
import '../../../features/main/data/repositories/get_user_repository_imp.dart';
import '../../../features/main/data/repositories/save_exclude_confirmation_repository_imp.dart';
import '../../../features/main/data/repositories/save_theme_mode_repository_imp.dart';
import '../../../features/main/domain/repositories/clear_user_repository.dart';
import '../../../features/main/domain/repositories/get_exclude_confirmation_repository.dart';
import '../../../features/main/domain/repositories/get_theme_mode_repository.dart';
import '../../../features/main/domain/repositories/get_user_repository.dart';
import '../../../features/main/domain/repositories/save_exclude_confirmation_repository.dart';
import '../../../features/main/domain/repositories/save_theme_mode_repository.dart';
import '../../../features/treatment/data/repositories/create_treatment_repository_imp.dart';
import '../../../features/treatment/data/repositories/delete_treatment_repository_imp.dart';
import '../../../features/treatment/data/repositories/get_treatments_repository_imp.dart';
import '../../../features/treatment/domain/repositories/create_treatment_repository.dart';
import '../../../features/treatment/domain/repositories/delete_treatment_repository.dart';
import '../../../features/treatment/domain/repositories/get_treatments_repository.dart';

class RepositoriesInjections {
  final GetIt getIt;

  RepositoriesInjections(this.getIt) {
    getIt.registerLazySingleton<CalculateExperimentRepository>(
      () => CalculateExperimentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<ClearUserRepository>(
      () => ClearUserRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateAccountRepository>(
      () => CreateAccountRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateEnzymeRepository>(
      () => CreateEnzymeRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateExperimentRepository>(
      () => CreateExperimentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateTreatmentRepository>(
      () => CreateTreatmentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteEnzymeRepository>(
      () => DeleteEnzymeRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteTreatmentRepository>(
      () => DeleteTreatmentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteExperimentRepository>(
      () => DeleteExperimentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetEnzymesRepository>(
      () => GetEnzymesRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetEnzymesRemainingInExperimentRepository>(
      () => GetEnzymesRemainingInExperimentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetExcludeConfirmationRepository>(
      () => GetExcludeConfirmationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetExperimentByIdRepository>(
      () => GetExperimentByIdRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetExperimentsRepository>(
      () => GetExperimentsRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetResultRepository>(
      () => GetResultRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetThemeModeRepository>(
      () => GetThemeModeRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetTreatmentsRepository>(
      () => GetTreatmentsRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<GetUserRepository>(
      () => GetUserRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<LoginRepository>(
      () => LoginRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<SaveExcludeConfirmationRepository>(
      () => SaveExcludeConfirmationRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<SaveResultRepository>(
      () => SaveResultRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<SaveThemeModeRepository>(
      () => SaveThemeModeRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<StoreExperimentsInCacheRepository>(
      () => StoreExperimentsInCacheRepositoryImp(getIt()),
    );
  }
}
