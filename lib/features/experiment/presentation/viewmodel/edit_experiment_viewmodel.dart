// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/usecases/experiments_usecases.dart';
import 'experiments_viewmodel.dart';

class EditExperimentViewmodel extends ChangeNotifier {
  final ExperimentsUseCases _experimentsUseCases;
  final ExperimentsViewmodel _experimentsViewmodel;

  EditExperimentViewmodel(this._experimentsUseCases, this._experimentsViewmodel);

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

  ExperimentEntity? _updatedExperiment;
  ExperimentEntity? get updatedExperiment => _updatedExperiment;

  void reset() {
    _updatedExperiment = null;
    setStateEnum(StateEnum.idle);
  }

  Future<void> save({
    required String experimentId,
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.updateExperiment(
      experimentId: experimentId,
      name: name,
      description: description,
      repetitions: repetitions,
      treatmentsIDs: treatmentsIDs,
      enzymes: enzymes,
    );

    await result.fold(
      (error) async {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        _updatedExperiment = success;
        await _experimentsViewmodel.fetch();
        setStateEnum(StateEnum.success);
      },
    );
  }
}
