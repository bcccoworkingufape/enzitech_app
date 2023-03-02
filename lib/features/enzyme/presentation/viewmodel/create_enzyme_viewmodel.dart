import 'package:flutter/material.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/create_enzyme/create_enzyme_usecase.dart';

class CreateEnzymeViewmodel extends ChangeNotifier {
  final CreateEnzymeUseCase _createEnzymeUseCase;

  CreateEnzymeViewmodel(
    this._createEnzymeUseCase,
  );

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

        var result = await _createEnzymeUseCase(
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

  @override
  void disposeValues() {
    setStateEnum(StateEnum.idle);
    _setFailure(null);
  }
}
