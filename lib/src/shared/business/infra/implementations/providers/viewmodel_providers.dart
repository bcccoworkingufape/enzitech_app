// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:enzitech_app/src/features/create_account/viewmodel/create_account_viewmodel.dart';
import 'package:enzitech_app/src/features/create_enzyme/viewmodel/create_enzyme_viewmodel.dart';
import 'package:enzitech_app/src/features/create_experiment/viewmodel/create_experiment_viewmodel.dart';
import 'package:enzitech_app/src/features/create_treatment/viewmodel/create_treatment_viewmodel.dart';
import 'package:enzitech_app/src/features/experiment_detailed/viewmodel/experiment_detailed_viewmodel.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/viewmodel/experiment_insert_data_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/account/viewmodel/account_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/enzymes/viewmodel/enzymes_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/treatments/viewmodel/treatments_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/features/recover_password/viewmodel/recover_password_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/auth_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/enzymes_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/experiments_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/treatments_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/controllers/user_controller.dart';

class ViewmodelProviders {
  static List<SingleChildWidget> init(
    BuildContext context,
  ) {
    return [
      //* AUTH VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => AuthViewmodel(
          authController: AuthController(
            authRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* CREATE ACCOUNT VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => CreateAccountViewmodel(
          userController: UserController(
            userRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* RECOVER PASSWORD VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => RecoverPasswordViewmodel(
          userController: UserController(
            userRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* ENZYMES VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => EnzymesViewmodel(
          enzymesController: EnzymesController(
            enzymesRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* TREATMENTS VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => TreatmentsViewmodel(
          treatmentsController: TreatmentsController(
            treatmentsRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* TREATMENTS VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => ExperimentsViewmodel(
          experimentsController: ExperimentsController(
            experimentsRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* ACCOUNT VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => AccountViewmodel(
          userPrefsServices: context.read(),
        ),
        lazy: true,
      ),
      //* HOME VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => HomeViewmodel(
          accountViewmodel: context.read(),
          experimentsViewmodel: context.read(),
          enzymesViewmodel: context.read(),
          treatmentsViewmodel: context.read(),
        ),
      ),
      //* CREATE ENZYME VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => CreateEnzymeViewmodel(
          enzymesController: EnzymesController(
            enzymesRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* CREATE TREATMENT VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => CreateTreatmentViewmodel(
          treatmentsController: TreatmentsController(
            treatmentsRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* CREATE EXPERIMENT VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => CreateExperimentViewmodel(
          experimentsController: ExperimentsController(
            experimentsRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* EXPERIMENT DETAILED VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => ExperimentDetailedViewmodel(
          experimentsController: ExperimentsController(
            experimentsRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
      //* EXPERIMENT INSERT DATA VIEWMODEL
      ChangeNotifierProvider(
        create: (context) => ExperimentInsertDataViewmodel(
          experimentsController: ExperimentsController(
            experimentsRepo: context.read(),
          ),
        ),
        lazy: true,
      ),
    ];
  }
}
