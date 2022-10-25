// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:enzitech_app/src/features/create_account/viewmodel/create_account_viewmodel.dart';
import 'package:enzitech_app/src/features/create_enzyme/create_enzyme_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_treatment/create_treatment_controller.dart';
import 'package:enzitech_app/src/features/experiment_detailed/experiment_detailed_controller.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/experiment_insert_data_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/features/recover_password/viewmodel/recover_password_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/auth_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/user_controller.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/auth_repo.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/repositories/user_repo.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/services_/enzymes_service.dart';
import 'package:enzitech_app/src/shared/services_/experiments_service.dart';
import 'package:enzitech_app/src/shared/services_/treatments_service.dart';
import 'package:enzitech_app/src/shared/services_/user_prefs_service.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';

class AppWidget extends StatelessWidget {
  final HttpDriverOptions httpDriverOptions;

  const AppWidget({Key? key, required this.httpDriverOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //* INIT DIO CLIENT
        Provider(
          create: (context) => DioClient(httpDriverOptions),
        ),

        //* INIT REPOSITORIES
        Provider(
          create: (context) => AuthRepo(context.read()),
          lazy: true,
        ),
        Provider(
          create: (context) => UserRepo(context.read()),
          lazy: true,
        ),

        //* INIT VIEWMODELS
        ChangeNotifierProvider(
          create: (context) => AuthViewmodel(
            authController: AuthController(
              authRepo: context.read(),
            ),
          ),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => CreateAccountViewmodel(
            userController: UserController(
              userRepo: context.read(),
            ),
          ),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => RecoverPasswordViewmodel(
            userController: UserController(
              userRepo: context.read(),
            ),
          ),
          lazy: true,
        ),

        // OLD
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
          lazy: true,
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
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => ExperimentDetailedController(
            ExperimentsService(context.read()),
          ),
          lazy: true,
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
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(
            accountController: context.read(),
            enzymesController: context.read(),
            experimentsController: context.read(),
            treatmentsController: context.read(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ExperimentInsertDataController(
            ExperimentsService(context.read()),
          ),
          lazy: true,
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
          title: 'Enzitech',
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
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: FormBuilderLocalizations.delegate.supportedLocales,
        ),
      ),
    );
  }
}
