// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models_/experiment_model.dart';
import 'package:enzitech_app/src/shared/services_/experiments_service.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

enum ExperimentDetailedState { idle, success, error, loading }

class ExperimentDetailedController extends ChangeNotifier {
  final ExperimentsService experimentsService;

  ExperimentDetailedController(
    this.experimentsService,
  );

  var state = ExperimentDetailedState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  ExperimentModel? _experiment;
  ExperimentModel? get experiment => _experiment;
  void _setExperimentModel(ExperimentModel experiment) {
    _experiment = experiment;
    notifyListeners();
  }

  Future<void> getExperimentDetailed(
    String id,
  ) async {
    state = ExperimentDetailedState.loading;
    // notifyListeners();
    try {
      var experiment = await experimentsService.getExperimentDetailed(id);
      _setExperimentModel(experiment);
      state = ExperimentDetailedState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentDetailedState.error;
      notifyListeners();
    }
  }
}
