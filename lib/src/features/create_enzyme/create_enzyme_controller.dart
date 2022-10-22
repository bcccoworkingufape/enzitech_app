// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/services_/enzymes_service.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

enum CreateEnzymeState { idle, success, error, loading }

class CreateEnzymeController extends ChangeNotifier {
  final EnzymesService enzymesService;

  CreateEnzymeController(
    this.enzymesService,
  );

  var state = CreateEnzymeState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> createEnzyme(
    String name,
    double variableA,
    double variableB,
    String type,
  ) async {
    state = CreateEnzymeState.loading;
    notifyListeners();
    try {
      await enzymesService.createEnzyme(name, variableA, variableB, type);

      state = CreateEnzymeState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = CreateEnzymeState.error;
      notifyListeners();
    }
  }
}
