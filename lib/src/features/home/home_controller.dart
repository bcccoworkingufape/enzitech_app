// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';

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
    try {
      await experimentsController.loadExperiments(1);
      await treatmentsController.loadTreatments();
      await enzymesController.loadEnzymes();
      await accountController.loadAccountFragment();

      notifyListeners();

      state = HomeState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = HomeState.error;
      notifyListeners();
    }
  }
}
