// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../domain/entities/http_driver_options.dart';
import 'injections/core_injections.dart';
import 'injections/datasources_injections.dart';
import 'injections/repositories_injections.dart';
import 'injections/usecases_injections.dart';
import 'injections/viewmodels_injections.dart';

GetIt getIt = GetIt.instance;

class Inject {
  //-> HttpDriverOptions é necessário para redefinir as opções de token do Dio.
  static void initialize(HttpDriverOptions httpDriverOptions) {
    CoreInjections(httpDriverOptions, getIt);

    DataSourcesInjections(getIt);

    RepositoriesInjections(getIt);

    UseCasesInjections(getIt);

    ViewmodelsInjections(getIt);
  }
}
