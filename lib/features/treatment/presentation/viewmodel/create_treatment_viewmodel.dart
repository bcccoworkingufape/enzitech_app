// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/treatments_usecases.dart';

class CreateTreatmentViewmodel extends ChangeNotifier {
  final TreatmentsUseCases _treatmentsUseCases;

  CreateTreatmentViewmodel(this._treatmentsUseCases);

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

  Future<void> createTreatment(String name, String description) async {
    setStateEnum(StateEnum.loading);

    var result = await _treatmentsUseCases.createTreatment(name: name, description: description);

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
