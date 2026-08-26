// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/treatment_entity.dart';
import '../../domain/usecases/treatments_usecases.dart';

class TreatmentsViewmodel extends ChangeNotifier {
  final TreatmentsUseCases _treatmentsUseCases;

  TreatmentsViewmodel(this._treatmentsUseCases);

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

    var result = await _treatmentsUseCases.getTreatments();

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
    var result = await _treatmentsUseCases.deleteTreatment(id);

    result.fold((error) {
      _setFailure(error);
      setStateEnum(StateEnum.error);
    }, (success) async {});
  }
}
