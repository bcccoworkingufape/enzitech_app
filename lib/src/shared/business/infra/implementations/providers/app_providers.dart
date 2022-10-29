// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';

class AppProviders {
  static List<IDisposableProvider> getDisposableProviders(
      BuildContext context) {
    return [
      Provider.of<AuthViewmodel>(context, listen: false),
      // TODO: Implement create_account
      // TODO: Implement create_enzyme
      // TODO: Implement create_experiment
      // TODO: Implement create_treatment
      // TODO: Implement experiment_detailed
      // TODO: Implement experiment_insert_data
      // TODO: Implement home
      // TODO: Implement account
      // TODO: Implement enzymes
      // TODO: Implement experiments
      // TODO: Implement treatments
      // TODO: Implement recover_password
      // TODO: Implement splash
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}
