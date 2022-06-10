// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/auth_page.dart';
import 'package:enzitech_app/src/features/create_account/create_account_page.dart';
import 'package:enzitech_app/src/features/home/home_page.dart';
import 'package:enzitech_app/src/features/recover_password/recover_password_page.dart';
import 'package:enzitech_app/src/features/splash/splash_page.dart';

import '../../features/create_experiment/create_experiment_page.dart';

class RouteGenerator {
  static const initial = "/";
  static const auth = "/auth";
  static const home = "/home";
  static const createAccount = "/createAccount";
  static const recoverPassword = "/recoverPassword";
  static const createExperiment = "/createExperiment";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case createAccount:
        return MaterialPageRoute(builder: (_) => const CreateAccountPage());
      case recoverPassword:
        return MaterialPageRoute(builder: (_) => const RecoverPasswordPage());
      case createExperiment:
        return MaterialPageRoute(builder: (_) => const CreateExperimentPage());
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
          body: const Center(
            child: Text('ERRO 404'),
          ),
        );
      },
    );
  }
}
