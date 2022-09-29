// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/services/enzymes_service.dart';

enum EnzymesState { idle, success, error, loading }

class EnzymesController extends ChangeNotifier {
  final EnzymesService enzymesService;

  EnzymesController(this.enzymesService);

  var state = EnzymesState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<EnzymeModel> _enzymes = [];
  List<EnzymeModel> get enzymes => _enzymes;
  void _setEnzymes(List<EnzymeModel> treatments) {
    _enzymes = treatments;
    notifyListeners();
  }

  Future<void> loadEnzymes() async {
    state = EnzymesState.loading;
    notifyListeners();
    try {
      final treatmentsList = await enzymesService.getEnzymes();
      _setEnzymes(treatmentsList);
      state = EnzymesState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = EnzymesState.error;
      notifyListeners();
    }
  }

  Future<void> deleteEnzyme(String id) async {
    // state = TreatmentsState.loading;
    // if (notify) notifyListeners();
    try {
      await enzymesService.deleteEnzyme(id);

      // state = TreatmentsState.success;
      // notifyListeners();
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = EnzymesState.error;
      notifyListeners();
    }
  }
}
