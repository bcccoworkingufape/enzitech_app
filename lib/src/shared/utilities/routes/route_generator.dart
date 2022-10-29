// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/ui/auth_page.dart';
import 'package:enzitech_app/src/features/create_account/ui/create_account_page.dart';
import 'package:enzitech_app/src/features/create_enzyme/ui/create_enzyme_page.dart';
import 'package:enzitech_app/src/features/create_experiment/ui/create_experiment_page.dart';
import 'package:enzitech_app/src/features/create_treatment/ui/create_treatment_page.dart';
import 'package:enzitech_app/src/features/experiment_detailed/ui/experiment_detailed_page.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/ui/experiment_insert_data_page.dart';
import 'package:enzitech_app/src/features/home/ui/home_page.dart';
import 'package:enzitech_app/src/features/recover_password/ui/recover_password_page.dart';
import 'package:enzitech_app/src/features/splash/splash_page.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_error.dart';

class RouteGenerator {
  static const auth = "/auth";
  static const createAccount = "/createAccount";
  static const createEnzyme = "/createEnzyme";
  static const createExperiment = "/createExperiment";
  static const createTreatment = "/createTreatment";
  static const experimentDetailed = "/experimentDetailed";
  static const experimentInsertData = "/experimentInsertData";
  static const home = "/home";
  static const initial = "/";
  static const recoverPassword = "/recoverPassword";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case createEnzyme:
        return MaterialPageRoute(builder: (_) => const CreateEnzymePage());
      case createExperiment:
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
        }
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case initial:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordPage());
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
