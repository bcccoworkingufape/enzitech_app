// 🐦 Flutter imports:
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/enzymes_viewmodel.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/experiments_viewmodel.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/fragments/treatments_viewmodel.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import 'fragments/account_viewmodel.dart';

class HomeViewmodel extends ChangeNotifier {
  // final GetEnzymesUseCase _getEnzymesUseCase;
  // final GetExperimentsUseCase _getExperimentsUseCase;
  // final GetTreatmentsUseCase _getTreatmentsUseCase;
  final ExperimentsViewmodel experimentsViewmodel;
  final EnzymesViewmodel enzymesViewmodel;
  final TreatmentsViewmodel treatmentsViewmodel;
  final AccountViewmodel accountViewmodel;

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

    /* resultExperiments.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        setExperiments(success);
        setStateEnum(StateEnum.success);
      },
    ); */

    /* var resultEnzymes = await _getEnzymesUseCase();

    resultEnzymes.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        setEnzymes(success);
        setStateEnum(StateEnum.success);
      },
    );

    var resultTreatments = await _getTreatmentsUseCase();

    resultTreatments.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        setTreatments(success);
        setStateEnum(StateEnum.success);
      },
    ); */
  }
}
