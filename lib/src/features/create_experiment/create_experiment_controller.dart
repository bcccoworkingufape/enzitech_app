// 🐦 Flutter imports:
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';

enum CreateExperimentState { idle, success, error, loading }

class CreateExperimentController extends ChangeNotifier {
  final ExperimentsService experimentService;

  CreateExperimentController(this.experimentService);

  var state = CreateExperimentState.idle;
  var experimentCreated = false;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  // ExperimentRequestModel _experimentRequestModel;
  // ExperimentRequestModel get experimentRequestModel => _experimentRequestModel;
  // void _setExperimentRequestModel(
  //   ExperimentRequestModel experimentRequestModel,
  // ) {
  //   _experimentRequestModel = experimentRequestModel;
  //   notifyListeners();
  // }

  List<EnzymeModel> _enzymes = [];
  List<EnzymeModel> get enzymes => _enzymes;
  void _setEnzymes(List<EnzymeModel> enzymes) {
    _enzymes = enzymes;
    notifyListeners();
  }

  Future<void> loadEnzymes() async {
    state = CreateExperimentState.loading;
    notifyListeners();
    try {
      final enzymesList = await experimentService.fetchEnzymes();
      _setEnzymes(enzymesList);

      state = CreateExperimentState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = CreateExperimentState.error;
      notifyListeners();
    }
  }

  Future<void> createExperiment(
    String name,
    String description,
    int repetitions,
    List<String> processes,
    List<EnzymeModel> experimentsEnzymes,
  ) async {
    state = CreateExperimentState.loading;
    notifyListeners();
    try {
      await experimentService.createExperiment(
        name,
        description,
        repetitions,
        processes,
        experimentsEnzymes,
      );

      state = CreateExperimentState.success;
      experimentCreated = true;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = CreateExperimentState.error;
      notifyListeners();
    }
  }
}
