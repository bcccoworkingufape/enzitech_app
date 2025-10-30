// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/domain/usecases/auth/auth_usecase.dart';
import '../../../features/authentication/domain/usecases/auth/auth_usecase_imp.dart';
import '../../../features/enzyme/domain/usecases/enzymes_usecases.dart';
import '../../../features/enzyme/domain/usecases/enzymes_usecases_imp.dart';
import '../../../features/experiment/domain/usecases/experiments_usecases.dart';
import '../../../features/experiment/domain/usecases/experiments_usecases_imp.dart';
import '../../../features/main/domain/usecases/user_preferences_usecases.dart';
import '../../../features/main/domain/usecases/user_preferences_usecases_imp.dart';
import '../../../features/treatment/domain/usecases/treatments_usecases.dart';
import '../../../features/treatment/domain/usecases/treatments_usecases_imp.dart';

class UseCasesInjections {
  final GetIt getIt;

  UseCasesInjections(this.getIt) {
    getIt.registerLazySingleton<EnzymesUseCases>(() => EnzymesUseCasesImp(getIt()));

    getIt.registerLazySingleton<TreatmentsUseCases>(() => TreatmentsUseCasesImp(getIt()));

    getIt.registerLazySingleton<ExperimentsUseCases>(() => ExperimentsUseCasesImp(getIt()));

    getIt.registerLazySingleton<UserPreferencesUseCases>(() => UserPreferencesUseCasesImp(getIt()));

    getIt.registerLazySingleton<AuthUseCase>(() => AuthUseCaseImp(getIt()));
  }
}
