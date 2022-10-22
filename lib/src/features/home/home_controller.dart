// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

enum HomeState { idle, success, error, loading }

class HomeController extends ChangeNotifier {
  final ExperimentsController experimentsController;
  final TreatmentsController treatmentsController;
  final EnzymesController enzymesController;
  final AccountController accountController;

  HomeController({
    required this.experimentsController,
    required this.treatmentsController,
    required this.enzymesController,
    required this.accountController,
  });

  var state = HomeState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  int _fragmentIndex = 0;
  int get fragmentIndex => _fragmentIndex;
  void setFragmentIndex(int fragmentIndex) {
    _fragmentIndex = fragmentIndex;
    notifyListeners();
  }

  void onFragmentTapped(int index) {
    setFragmentIndex(index);
  }

  Future<void> getContent() async {
    state = HomeState.loading;
    notifyListeners();
    // try {
    await experimentsController.loadExperiments(1);
    await treatmentsController.loadTreatments();
    await enzymesController.loadEnzymes();
    await accountController.loadAccountFragment();

    notifyListeners();

    if (experimentsController.state == ExperimentsState.error) {
      _setFailure(experimentsController.failure!);
      state = HomeState.error;
    } else if (treatmentsController.state == ExperimentsState.error) {
      _setFailure(treatmentsController.failure!);

      state = HomeState.error;
    } else if (enzymesController.state == EnzymesState.error) {
      _setFailure(enzymesController.failure!);

      state = HomeState.error;
    } else if (accountController.state == AccountState.error) {
      _setFailure(accountController.failure!);

      state = HomeState.success;
    } /*  else if (experimentsController.state == ExperimentsState.success &&
          treatmentsController.state == ExperimentsState.success &&
          enzymesController.state == EnzymesState.success &&
          accountController.state == AccountState.success) {
        state = HomeState.success;
      } */
    else {
      state = HomeState.success;
    }

    notifyListeners();
    // } catch (e) {
    //   _setFailure(e as Failure);
    //   state = HomeState.error;
    //   notifyListeners();
    // }
  }
}
