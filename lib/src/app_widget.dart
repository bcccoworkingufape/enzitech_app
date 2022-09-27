// 🐦 Flutter imports:
import 'package:enzitech_app/src/features/create_enzyme/create_enzyme_controller.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/auth_controller.dart';
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_treatment/create_treatment_controller.dart';
import 'package:enzitech_app/src/features/experiment_detailed/experiment_detailed_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/features/recover_password/recover_password_controller.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/services/auth_service.dart';
import 'package:enzitech_app/src/shared/services/enzymes_service.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';
import 'package:enzitech_app/src/shared/services/treatments_service.dart';
import 'package:enzitech_app/src/shared/services/user_prefs_service.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

class AppWidget extends StatelessWidget {
  final HttpDriverOptions httpDriverOptions;

  const AppWidget({Key? key, required this.httpDriverOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => DioClient(httpDriverOptions),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(
            context.read(),
            AuthService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateAccountController(
            context.read(),
            AuthService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RecoverPasswordController(context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountController(
            UserPrefsServices(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ExperimentsController(
            ExperimentsService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateExperimentController(
            ExperimentsService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => TreatmentsController(
            TreatmentsService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateTreatmentController(
            TreatmentsService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ExperimentDetailedController(
            ExperimentsService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EnzymesController(
            EnzymesService(context.read()),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateEnzymeController(
            EnzymesService(context.read()),
          ),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: AppColors.white,
              ),
            ),
            primarySwatch: AppColors.materialTheme,
          ),
          initialRoute: RouteGenerator.initial,
          onGenerateRoute: RouteGenerator.generateRoute,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
