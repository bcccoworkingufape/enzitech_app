// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';

enum ExperimentsState { idle, success, error, loading }

class ExperimentsController extends ChangeNotifier {
  final ExperimentsService experimentsService;

  ExperimentsController(this.experimentsService);

  var state = ExperimentsState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  List<ExperimentModel> _experiments = [];
  List<ExperimentModel> get experiments => _experiments;
  void _setExperiments(List<ExperimentModel> experiments) {
    _experiments = experiments;
    notifyListeners();
  }

  Future<void> loadExperiments() async {
    state = ExperimentsState.loading;
    notifyListeners();
    try {
      // var experimentsService = ExperimentsService(client);

      final experimentsList = await experimentsService.fetchExperiments();
      _setExperiments(experimentsList);

      state = ExperimentsState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentsState.error;
      notifyListeners();
    }
  }
}
