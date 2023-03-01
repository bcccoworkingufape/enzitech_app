import 'package:get_it/get_it.dart';

import '../../../features/authentication/domain/usecases/create_account/create_account_usecase.dart';
import '../../../features/authentication/domain/usecases/create_account/create_account_usecase_imp.dart';
import '../../../features/authentication/domain/usecases/login/login_usecase.dart';
import '../../../features/authentication/domain/usecases/login/login_usecase_imp.dart';
import '../../../features/enzyme/domain/usecases/delete_enzyme/delete_enzyme_usecase.dart';
import '../../../features/enzyme/domain/usecases/delete_enzyme/delete_enzyme_usecase_imp.dart';
import '../../../features/enzyme/domain/usecases/get_enzymes/get_enzymes_usecase.dart';
import '../../../features/enzyme/domain/usecases/get_enzymes/get_enzymes_usecase_imp.dart';
import '../../../features/experiment/domain/usecases/delete_experiment/delete_experiment_usecase.dart';
import '../../../features/experiment/domain/usecases/delete_experiment/delete_experiment_usecase_imp.dart';
import '../../../features/experiment/domain/usecases/get_experiments/get_experiments_usecase.dart';
import '../../../features/experiment/domain/usecases/get_experiments/get_experiments_usecase_imp.dart';
import '../../../features/experiment/domain/usecases/store_experiments_in_cache/store_experiments_in_cache_usecase.dart';
import '../../../features/experiment/domain/usecases/store_experiments_in_cache/store_experiments_in_cache_usecase_imp.dart';
import '../../../features/main/domain/usecases/clear_user/clear_user_usecase.dart';
import '../../../features/main/domain/usecases/clear_user/clear_user_usecase_imp.dart';
import '../../../features/main/domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase.dart';
import '../../../features/main/domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase_imp.dart';
import '../../../features/main/domain/usecases/get_user/get_user_usecase.dart';
import '../../../features/main/domain/usecases/get_user/get_user_usecase_imp.dart';
import '../../../features/main/domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase.dart';
import '../../../features/main/domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase_imp.dart';
import '../../../features/treatment/domain/usecases/delete_treatment/delete_treatment_usecase.dart';
import '../../../features/treatment/domain/usecases/delete_treatment/delete_treatment_usecase_imp.dart';
import '../../../features/treatment/domain/usecases/get_treatments/get_treatments_usecase.dart';
import '../../../features/treatment/domain/usecases/get_treatments/get_treatments_usecase_imp.dart';

class UseCasesInjections {
  final GetIt getIt;

  UseCasesInjections(this.getIt) {
    getIt.registerLazySingleton<DeleteEnzymeUseCase>(
      () => DeleteEnzymeUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteTreatmentUseCase>(
      () => DeleteTreatmentUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<DeleteExperimentUseCase>(
      () => DeleteExperimentUseCaseImp(getIt()),
    );
    getIt.registerLazySingleton<CreateAccountUseCase>(
      () => CreateAccountUseCaseImp(getIt()),
    );
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
  }
}
