// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/enzymes_usecases.dart';

class CreateEnzymeViewmodel extends ChangeNotifier {
  final EnzymesUseCases _enzymesUseCases;

  CreateEnzymeViewmodel(this._enzymesUseCases);

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

  Future<void> createEnzyme(String name, double variableA, double variableB, String type) async {
    setStateEnum(StateEnum.loading);

    var result = await _enzymesUseCases.createEnzyme(
      name: name,
      variableA: variableA,
      variableB: variableB,
      type: type,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setStateEnum(StateEnum.success);
      },
    );
  }
}
