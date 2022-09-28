// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/treatment_model.dart';
import 'package:enzitech_app/src/shared/services/treatments_service.dart';

enum TreatmentsState { idle, success, error, loading }

class TreatmentsController extends ChangeNotifier {
  final TreatmentsService treatmentsService;

  TreatmentsController(this.treatmentsService);

  var state = TreatmentsState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<TreatmentModel> _treatments = [];
  List<TreatmentModel> get treatments => _treatments;
  void _setTreatments(List<TreatmentModel> treatments) {
    _treatments = treatments;
    notifyListeners();
  }

  Future<void> loadTreatments() async {
    state = TreatmentsState.loading;
    notifyListeners();
    try {
      final treatmentsList = await treatmentsService.fetchTreatments();
      _setTreatments(treatmentsList);
      state = TreatmentsState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = TreatmentsState.error;
      notifyListeners();
    }
  }

  Future<void> deleteTreatment(String id) async {
    // state = TreatmentsState.loading;
    // notifyListeners();
    try {
      await treatmentsService.deleteTreatment(id);

      // state = TreatmentsState.success;
      // notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = TreatmentsState.error;
      notifyListeners();
    }
  }
}
