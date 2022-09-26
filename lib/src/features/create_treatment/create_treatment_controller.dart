// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/services/treatments_service.dart';

enum CreateTreatmentState { idle, success, error, loading }

class CreateTreatmentController extends ChangeNotifier {
  final TreatmentsService treatmentsService;

  CreateTreatmentController(
    this.treatmentsService,
  );

  var state = CreateTreatmentState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  Future<void> createTreatment(
    String name,
    String description,
  ) async {
    state = CreateTreatmentState.loading;
    notifyListeners();
    try {
      await treatmentsService.createTreatment(name, description);

      state = CreateTreatmentState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = CreateTreatmentState.error;
      notifyListeners();
    }
  }
}
