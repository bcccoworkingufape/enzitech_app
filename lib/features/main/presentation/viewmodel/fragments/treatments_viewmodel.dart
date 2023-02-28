// import 'package:enzitech_app/features/home/data/datasources/get_enzymes_datasource.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../core/enums/enums.dart';
import '../../../../../core/failures/failures.dart';
import '../../../domain/entities/treatment_entity.dart';
import '../../../domain/usecases/get_treatments/get_treatments_usecase.dart';

class TreatmentsViewmodel extends ChangeNotifier {
  final GetTreatmentsUseCase _getTreatmentsUseCase;

  TreatmentsViewmodel(
    this._getTreatmentsUseCase,
  ) {
    // fetch();
  }

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

  Future<void> fetch({int pagination = 1}) async {
    setStateEnum(StateEnum.loading);

    var result = await _getTreatmentsUseCase();

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        _setTreatments(success);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> deleteTreatment(String id) async {
    setStateEnum(StateEnum.loading);

    try {
      // await treatmentsController.deleteTreatment(id);
      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }
}
