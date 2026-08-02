// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/usecases/experiments_usecases.dart';

class ExperimentDetailsViewmodel extends ChangeNotifier {
  final ExperimentsUseCases _experimentsUseCases;

  ExperimentDetailsViewmodel(this._experimentsUseCases);

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

  Future<void> getExperimentDetails(String id) async {
    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.getExperimentById(id);

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

  Future<void> updateEnzymeFormula({
    required String experimentEnzymeId,
    String? customFormulaCurve,
    String? customFormulaCalculation,
  }) async {
    if (_experiment == null) return;

    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.updateEnzymeFormula(
      experimentId: _experiment!.id,
      experimentEnzymeId: experimentEnzymeId,
      customFormulaCurve: customFormulaCurve,
      customFormulaCalculation: customFormulaCalculation,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (updatedEnzyme) {
        final enzymes = _experiment!.enzymes ?? [];
        final index = enzymes.indexWhere((e) => e.id == updatedEnzyme.id);
        if (index != -1) {
          enzymes[index] = updatedEnzyme;
        }
        setStateEnum(StateEnum.success);
      },
    );
  }
}
