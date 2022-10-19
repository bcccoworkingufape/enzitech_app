// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';

enum ExperimentInsertDataState { idle, success, error, loading }

class ExperimentInsertDataController extends ChangeNotifier {
  final ExperimentsService experimentsService;

  ExperimentInsertDataController(
    this.experimentsService,
  );

  var state = ExperimentInsertDataState.idle;

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

  Future<void> insertExperimentData(
    String id,
  ) async {
    state = ExperimentInsertDataState.loading;
    // notifyListeners();
    try {
      var experiment = await experimentsService.calculateExperiment(id);
      // _setExperimentModel(experiment);
      state = ExperimentInsertDataState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentInsertDataState.error;
      notifyListeners();
    }
  }
}
