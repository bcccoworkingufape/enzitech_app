// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';

enum CreateExperimentState { idle, success, error, loading }

class CreateExperimentController extends ChangeNotifier {
  final DioClient client;

  CreateExperimentController(this.client);

  var state = CreateExperimentState.idle;

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

  Future<void> createExperiment(
    String name,
    String description,
    int repetitions,
    // List<String> processes,
    // List<EnzymeModel> experimentsEnzymes,
  ) async {
    state = CreateExperimentState.loading;
    notifyListeners();
    try {
      var experimentService = ExperimentsService(client);

      await experimentService.createExperiment(name, description, repetitions);

      state = CreateExperimentState.success;
      notifyListeners();
    } on Failure catch (failure) {
      _setFailure(ServerFailure(message: failure.message));
      state = CreateExperimentState.error;
      notifyListeners();
    } catch (e) {
      _setFailure(UnknownError());
      state = CreateExperimentState.error;
      notifyListeners();
    }
  }
}
