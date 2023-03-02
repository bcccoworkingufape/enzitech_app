// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../features/authentication/presentation/ui/pages/create_account/create_account_page.dart';
import '../../features/authentication/presentation/ui/pages/login/login_page.dart';
import '../../features/enzyme/presentation/ui/pages/create_enzyme/create_enzyme_page.dart';
import '../../features/main/presentation/ui/pages/home/home_page.dart';
import '../../features/main/presentation/ui/pages/splash/splash_page.dart';
import '../../shared/ui/ui.dart';

class Routing {
  static const createAccount = "/createAccount";
  static const createEnzyme = "/createEnzyme";
  static const createExperiment = "/createExperiment";
  static const createTreatment = "/createTreatment";
  static const experimentDetailed = "/experimentDetailed";
  static const experimentInsertData = "/experimentInsertData";
  static const home = "/home";
  static const initial = "/";
  static const login = "/login";
  static const recoverPassword = "/recoverPassword";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case createEnzyme:
        return MaterialPageRoute(builder: (_) => const CreateEnzymePage());
      /* case createExperiment:
        return MaterialPageRoute(builder: (_) => const CreateExperimentPage());
      case createTreatment:
        return MaterialPageRoute(builder: (_) => const CreateTreatmentPage());
      case experimentDetailed:
        if (args is ExperimentEntity) {
          return MaterialPageRoute(
            builder: (_) => ExperimentDetailedPage(
              resumedExperiment: args,
            ),
          );
        } else {
          return _errorRoute();
        }
      case experimentInsertData:
        if (args is ExperimentEntity) {
          return MaterialPageRoute(
            builder: (_) => ExperimentInsertDataPage(
              experiment: args,
            ),
          );
        } else {
          return _errorRoute();
        }*/
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case initial:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      /* case recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordPage()); */
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('Sem rota definida para "${settings.name}"')),
          ),
        );
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Não encontrado'),
          ),
          body: const EZTError(message: 'ERRO 404'),
        );
      },
    );
  }
}
