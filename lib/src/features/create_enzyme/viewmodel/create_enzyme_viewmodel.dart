// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/enzymes_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class CreateEnzymeViewmodel extends IDisposableProvider {
  final EnzymesController enzymesController;

  CreateEnzymeViewmodel({
    required this.enzymesController,
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

  Future<void> createEnzyme(
    String name,
    double variableA,
    double variableB,
    String type,
  ) async {
    setStateEnum(StateEnum.loading);
    try {
      await enzymesController.createEnzyme(
        name: name,
        variableA: variableA,
        variableB: variableB,
        type: type,
      );

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
