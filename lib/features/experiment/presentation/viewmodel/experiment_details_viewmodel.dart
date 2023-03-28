// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/usecases/get_experiment_by_id/get_experiment_by_id_usecase.dart';

class ExperimentDetailsViewmodel extends ChangeNotifier {
  final GetExperimentByIdUseCase _getExperimentByIdUseCase;

  ExperimentDetailsViewmodel(this._getExperimentByIdUseCase);

  StateEnum _state = StateEnum.idle;
  StateEnum get state => _state;
  void setStateEnum(StateEnum state) {
    _state = state;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure? failure) {
    _failure = failure;
  }

  ExperimentEntity? _experiment;
  ExperimentEntity? get experiment => _experiment;
  void setExperiment(ExperimentEntity experiment) {
    _experiment = experiment;
    notifyListeners();
  }

  Future<void> getExperimentDetails(
    String id,
  ) async {
    setStateEnum(StateEnum.loading);

    var result = await _getExperimentByIdUseCase(id);

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setExperiment(success);
        setStateEnum(StateEnum.success);
      },
    );
  }
}
