// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/treatments_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/treatment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class TreatmentsViewmodel extends IDisposableProvider {
  final TreatmentsController treatmentsController;

  TreatmentsViewmodel({
    required this.treatmentsController,
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

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  List<TreatmentEntity> _treatments = [];
  List<TreatmentEntity> get treatments => _treatments;
  void _setTreatments(List<TreatmentEntity> treatments) {
    _treatments = treatments;
    notifyListeners();
  }

  Future<void> loadTreatments() async {
    setStateEnum(StateEnum.loading);

    try {
      final treatmentsList = await treatmentsController.getTreatments();
      _setTreatments(treatmentsList);
      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> deleteTreatment(String id) async {
    setStateEnum(StateEnum.loading);

    try {
      await treatmentsController.deleteTreatment(id);
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
    //? TODO: test clear _setTreatments
  }
}
