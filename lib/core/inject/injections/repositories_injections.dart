import 'package:get_it/get_it.dart';

import '../../../features/authentication/data/repositories/create_account_repository_imp.dart';
import '../../../features/authentication/data/repositories/login_repository_imp.dart';
import '../../../features/authentication/domain/repositories/create_account_repository.dart';
import '../../../features/authentication/domain/repositories/login_repository.dart';
import '../../../features/enzyme/data/repositories/delete_enzyme_repository_imp.dart';
import '../../../features/enzyme/data/repositories/get_enzymes_repository_imp.dart';
import '../../../features/enzyme/domain/repositories/delete_enzyme_repository.dart';
import '../../../features/enzyme/domain/repositories/get_enzymes_repository.dart';
import '../../../features/experiment/data/repositories/delete_experiment_repository_imp.dart';
import '../../../features/experiment/data/repositories/get_experiments_repository_imp.dart';
import '../../../features/experiment/data/repositories/store_experiments_in_cache_repository_imp.dart';
import '../../../features/experiment/domain/repositories/delete_experiment_repository.dart';
import '../../../features/experiment/domain/repositories/get_experiments_repository.dart';
import '../../../features/experiment/domain/repositories/store_experiments_in_cache_repository.dart';
import '../../../features/main/data/repositories/clear_user_repository_imp.dart';
import '../../../features/main/data/repositories/get_exclude_confirmation_repository_imp.dart';
import '../../../features/main/data/repositories/get_user_repository_imp.dart';
import '../../../features/main/data/repositories/save_exclude_confirmation_repository_imp.dart';
import '../../../features/main/domain/repositories/clear_user_repository.dart';
import '../../../features/main/domain/repositories/get_exclude_confirmation_repository.dart';
import '../../../features/main/domain/repositories/get_user_repository.dart';
import '../../../features/main/domain/repositories/save_exclude_confirmation_repository.dart';
import '../../../features/treatment/data/repositories/delete_treatment_repository_imp.dart';
import '../../../features/treatment/data/repositories/get_treatments_repository_imp.dart';
import '../../../features/treatment/domain/repositories/delete_treatment_repository.dart';
import '../../../features/treatment/domain/repositories/get_treatments_repository.dart';

class RepositoriesInjections {
  final GetIt getIt;
  
  RepositoriesInjections(this.getIt) {
    getIt.registerLazySingleton<DeleteEnzymeRepository>(
      () => DeleteEnzymeRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteTreatmentRepository>(
      () => DeleteTreatmentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteExperimentRepository>(
      () => DeleteExperimentRepositoryImp(getIt()),
    );
    getIt.registerLazySingleton<CreateAccountRepository>(
      () => CreateAccountRepositoryImp(getIt()),
    );
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
  }
}
