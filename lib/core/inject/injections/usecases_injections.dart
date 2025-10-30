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
import '../../../features/main/domain/usecases/clear_user/clear_user_usecase.dart';
import '../../../features/main/domain/usecases/clear_user/clear_user_usecase_imp.dart';
import '../../../features/main/domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase.dart';
import '../../../features/main/domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase_imp.dart';
import '../../../features/main/domain/usecases/get_replace_language/get_replace_language.dart';
import '../../../features/main/domain/usecases/get_replace_language/get_replace_language_imp.dart';
import '../../../features/main/domain/usecases/get_theme_mode/get_theme_mode_usecase.dart';
import '../../../features/main/domain/usecases/get_theme_mode/get_theme_mode_usecase_imp.dart';
import '../../../features/main/domain/usecases/get_user/get_user_usecase.dart';
import '../../../features/main/domain/usecases/get_user/get_user_usecase_imp.dart';
import '../../../features/main/domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase.dart';
import '../../../features/main/domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase_imp.dart';
import '../../../features/main/domain/usecases/save_replace_language/save_replace_language.dart';
import '../../../features/main/domain/usecases/save_replace_language/save_replace_language_imp.dart';
import '../../../features/main/domain/usecases/save_theme_mode/save_theme_mode_usecase.dart';
import '../../../features/main/domain/usecases/save_theme_mode/save_theme_mode_usecase_imp.dart';
import '../../../features/treatment/domain/usecases/treatments_usecases.dart';
import '../../../features/treatment/domain/usecases/treatments_usecases_imp.dart';

class UseCasesInjections {
  final GetIt getIt;

  UseCasesInjections(this.getIt) {
    getIt.registerLazySingleton<EnzymesUseCases>(() => EnzymesUseCasesImp(getIt()));

    getIt.registerLazySingleton<TreatmentsUseCases>(() => TreatmentsUseCasesImp(getIt()));

    getIt.registerLazySingleton<ExperimentsUseCases>(() => ExperimentsUseCasesImp(getIt()));

    getIt.registerLazySingleton<ClearUserUseCase>(() => ClearUserUseCaseImp(getIt()));
    getIt.registerLazySingleton<CreateAccountUseCase>(() => CreateAccountUseCaseImp(getIt()));
    getIt.registerLazySingleton<GetExcludeConfirmationUseCase>(() => GetExcludeConfirmationUseCaseImp(getIt()));
    getIt.registerLazySingleton<GetThemeModeUseCase>(() => GetThemeModeUseCaseImp(getIt()));
    getIt.registerLazySingleton<GetUserUseCase>(() => GetUserUseCaseImp(getIt()));
    getIt.registerLazySingleton<GetReplaceLanguageUseCase>(() => GetReplaceLanguageUseCaseImp(getIt()));
    getIt.registerLazySingleton<LoginUseCase>(() => LoginUseCaseImp(getIt()));
    getIt.registerLazySingleton<SaveExcludeConfirmationUseCase>(() => SaveExcludeConfirmationUseCaseImp(getIt()));
    getIt.registerLazySingleton<SaveThemeModeUseCase>(() => SaveThemeModeUseCaseImp(getIt()));
    getIt.registerLazySingleton<SaveReplaceLanguageUseCase>(() => SaveReplaceLanguageUseCaseImp(getIt()));
  }
}
