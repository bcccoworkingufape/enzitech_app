// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../features/authentication/presentation/ui/pages/create_account/create_account_page.dart';
import '../../features/authentication/presentation/ui/pages/login/login_page.dart';
import '../../features/enzyme/presentation/ui/pages/create_enzyme/create_enzyme_page.dart';
import '../../features/experiment/domain/entities/experiment_entity.dart';
import '../../features/experiment/presentation/ui/pages/calculate_experiment/calculate_experiment_page.dart';
import '../../features/experiment/presentation/ui/pages/create_experiment/create_experiment_page.dart';
import '../../features/experiment/presentation/ui/pages/experiment_details/experiment_details_page.dart';
import '../../features/experiment/presentation/ui/pages/experiment_results/experiment_results_page.dart';
import '../../features/main/presentation/ui/pages/home/home_page.dart';
import '../../features/main/presentation/ui/pages/splash/splash_page.dart';
import '../../features/treatment/presentation/ui/pages/create_treatment/create_treatment_page.dart';
import '../../shared/ui/ui.dart';

class Routing {
  static const createAccount = "/createAccount";
  static const createEnzyme = "/createEnzyme";
  static const createExperiment = "/createExperiment";
  static const createTreatment = "/createTreatment";
  static const experimentDetailed = "/experimentDetailed";
  static const experimentResults = "/experimentResults";
  static const calculateExperiment = "/experimentInsertData";
  static const home = "/home";
  static const initial = "/";
  static const login = "/login";
  static const recoverPassword = "/recoverPassword";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          settings: const RouteSettings(name: login),
          builder: (_) => const LoginPage(),
        );
      case createAccount:
        return MaterialPageRoute(
          settings: const RouteSettings(name: createAccount),
          builder: (_) => const CreateAccountPage(),
        );
      case createEnzyme:
        return MaterialPageRoute(
          settings: const RouteSettings(name: createEnzyme),
          builder: (_) => const CreateEnzymePage(),
        );
      case createExperiment:
        return MaterialPageRoute(
          settings: const RouteSettings(name: createExperiment),
          builder: (_) => const CreateExperimentPage(),
        );
      case createTreatment:
        return MaterialPageRoute(
          settings: const RouteSettings(name: createTreatment),
          builder: (_) => const CreateTreatmentPage(),
        );
      case experimentDetailed:
        return MaterialPageRoute(
          settings: const RouteSettings(name: experimentDetailed),
          builder: (_) => const ExperimentDetailsPage(),
        );
      case experimentResults:
        return MaterialPageRoute(
          settings: const RouteSettings(name: experimentResults),
          builder: (_) => const ExperimentResultsPage(),
        );
      case calculateExperiment:
        if (args is ExperimentEntity) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: calculateExperiment),
            builder: (_) => CalculateExperimentPage(
              experiment: args,
            ),
          );
        } else {
          return _errorRoute();
        }
      case home:
        return MaterialPageRoute(
          settings: const RouteSettings(name: home),
          builder: (_) => const HomePage(),
        );
      case initial:
        return MaterialPageRoute(
          settings: const RouteSettings(name: initial),
          builder: (_) => const SplashPage(),
        );
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
