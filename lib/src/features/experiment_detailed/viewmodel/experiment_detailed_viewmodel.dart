// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/experiments_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class ExperimentDetailedViewmodel extends IDisposableProvider {
  final ExperimentsController experimentsController;

  ExperimentDetailedViewmodel({
    required this.experimentsController,
  });

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
  void _setExperiment(ExperimentEntity experiment) {
    _experiment = experiment;
    notifyListeners();
  }

  Future<void> getExperimentDetailed(
    String id,
  ) async {
    setStateEnum(StateEnum.loading);
    try {
      var experiment = await experimentsController.getExperimentDetailed(id);
      _setExperiment(experiment);
      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  @override
  void disposeValues() {
    setStateEnum(StateEnum.idle);
    _setFailure(null);
  }
}
