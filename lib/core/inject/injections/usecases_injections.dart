// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/domain/usecases/create_account/create_account_usecase.dart';
import '../../../features/authentication/domain/usecases/create_account/create_account_usecase_imp.dart';
import '../../../features/authentication/domain/usecases/login/login_usecase.dart';
import '../../../features/authentication/domain/usecases/login/login_usecase_imp.dart';
import '../../../features/enzyme/domain/usecases/enzymes_usecases.dart';
import '../../../features/enzyme/domain/usecases/enzymes_usecases_imp.dart';
import '../../../features/experiment/domain/usecases/experiments_usecases.dart';
import '../../../features/experiment/domain/usecases/experiments_usecases_imp.dart';
import '../../../features/main/domain/usecases/users_usecases.dart';
import '../../../features/main/domain/usecases/users_usecases_imp.dart';
import '../../../features/treatment/domain/usecases/treatments_usecases.dart';
import '../../../features/treatment/domain/usecases/treatments_usecases_imp.dart';

class UseCasesInjections {
  final GetIt getIt;

  UseCasesInjections(this.getIt) {
    getIt.registerLazySingleton<EnzymesUseCases>(() => EnzymesUseCasesImp(getIt()));

    getIt.registerLazySingleton<TreatmentsUseCases>(() => TreatmentsUseCasesImp(getIt()));

    getIt.registerLazySingleton<ExperimentsUseCases>(() => ExperimentsUseCasesImp(getIt()));

    getIt.registerLazySingleton<UsersUseCases>(() => UsersUseCasesImp(getIt()));

    getIt.registerLazySingleton<CreateAccountUseCase>(() => CreateAccountUseCaseImp(getIt()));

    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCaseImp(getIt()));
  }
}
