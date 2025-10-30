// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../features/authentication/data/repositories/create_account_repository_imp.dart';
import '../../../features/authentication/data/repositories/login_repository_imp.dart';
import '../../../features/authentication/domain/repositories/create_account_repository.dart';
import '../../../features/authentication/domain/repositories/login_repository.dart';
import '../../../features/enzyme/data/repositories/enzymes_repository_imp.dart';
import '../../../features/enzyme/domain/repositories/enzymes_repository.dart';
import '../../../features/experiment/data/repositories/experiments_repository_imp.dart';
import '../../../features/experiment/domain/repositories/experiments_repository.dart';
import '../../../features/main/data/repositories/users_repository_imp.dart';
import '../../../features/main/domain/repositories/users_repository.dart';
import '../../../features/treatment/data/repositories/treatments_repository_imp.dart';
import '../../../features/treatment/domain/repositories/treatments_repository.dart';

class RepositoriesInjections {
  final GetIt getIt;

  RepositoriesInjections(this.getIt) {
    getIt.registerLazySingleton<EnzymesRepository>(() => EnzymesRepositoryImp(getIt()));

    getIt.registerLazySingleton<TreatmentsRepository>(() => TreatmentsRepositoryImp(getIt()));

    getIt.registerLazySingleton<ExperimentsRepository>(() => ExperimentsRepositoryImp(getIt()));

    getIt.registerLazySingleton<UsersRepository>(() => UsersRepositoryImp(getIt()));

    getIt.registerLazySingleton<CreateAccountRepository>(() => CreateAccountRepositoryImp(getIt()));

    getIt.registerLazySingleton<LoginRepository>(() => LoginRepositoryImp(getIt()));
  }
}
