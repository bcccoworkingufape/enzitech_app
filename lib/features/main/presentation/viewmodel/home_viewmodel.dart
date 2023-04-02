// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../experiment/presentation/viewmodel/experiments_viewmodel.dart';
import '../../../treatment/presentation/viewmodel/treatments_viewmodel.dart';
import 'account_viewmodel.dart';

class HomeViewmodel extends ChangeNotifier {
  final ExperimentsViewmodel experimentsViewmodel;
  final EnzymesViewmodel enzymesViewmodel;
  final TreatmentsViewmodel treatmentsViewmodel;
  final SettingsViewmodel accountViewmodel;

  HomeViewmodel(
    this.experimentsViewmodel,
    this.enzymesViewmodel,
    this.treatmentsViewmodel,
    this.accountViewmodel,
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

  int _fragmentIndex = 0;
  int get fragmentIndex => _fragmentIndex;
  void setFragmentIndex(int fragmentIndex) {
    _fragmentIndex = fragmentIndex;
    notifyListeners();
  }

  bool _hasInternetConnection = true;
  bool get hasInternetConnection => _hasInternetConnection;
  bool previousHasInternetConnection = true;
  bool get notifyInternetConnection =>
      previousHasInternetConnection != _hasInternetConnection;

  void setHasInternetConnection(bool flag) {
    previousHasInternetConnection = _hasInternetConnection;
    _hasInternetConnection = flag;
    notifyListeners();
  }

  fetch() async {
    setStateEnum(StateEnum.loading);
    await experimentsViewmodel.fetch();
    await enzymesViewmodel.fetch();
    await treatmentsViewmodel.fetch();
    await accountViewmodel.fetch();

    if (experimentsViewmodel.state == StateEnum.error) {
      _setFailure(experimentsViewmodel.failure);
      setStateEnum(StateEnum.error);
    } else if (enzymesViewmodel.state == StateEnum.error) {
      _setFailure(enzymesViewmodel.failure);
      setStateEnum(StateEnum.error);
    } else if (treatmentsViewmodel.state == StateEnum.error) {
      _setFailure(treatmentsViewmodel.failure);
      setStateEnum(StateEnum.error);
    } else if (accountViewmodel.state == StateEnum.error) {
      _setFailure(accountViewmodel.failure);
      setStateEnum(StateEnum.error);
    }

    setStateEnum(StateEnum.success);
  }
}
