// import 'package:enzitech_app/features/home/data/datasources/get_enzymes_datasource.dart';

// 🐦 Flutter imports:
import 'package:enzitech_app/features/main/domain/entities/treatment_entity.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/enzyme_entity.dart';
import '../../domain/usecases/get_enzymes/get_enzymes_usecase.dart';
import '../../domain/usecases/get_experiments/get_experiments_usecase.dart';
import '../../domain/usecases/get_treatments/get_treatments_usecase.dart';

class HomeViewmodel extends ChangeNotifier {
  final GetEnzymesUseCase _getEnzymesUseCase;
  final GetExperimentsUseCase _getExperimentsUseCase;
  final GetTreatmentsUseCase _getTreatmentsUseCase;
  // final GetEnzymesUseCase _getEnzymesUseCase;
  // final GetEnzymesUseCase _getEnzymesUseCase;
  // final GetEnzymesUseCase _getEnzymesUseCase;

  HomeViewmodel(
    this._getEnzymesUseCase,
    this._getExperimentsUseCase,
    this._getTreatmentsUseCase,
  ) {
    fetch();
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

  List<EnzymeEntity>? _enzymes;
  List<EnzymeEntity>? get enzymes => _enzymes;
  void setEnzymes(List<EnzymeEntity>? enzymes) {
    _enzymes = enzymes;
    notifyListeners();
  }

  // List<EnzymeEntity>? _cachedEnzymes;

  List<TreatmentEntity>? _treatments;
  List<TreatmentEntity>? get treatments => _treatments;
  void setTreatments(List<TreatmentEntity>? treatments) {
    _treatments = treatments;
    notifyListeners();
  }

  /* onChanged(String value) {
    List<MovieDetailsEntity> list = _cachedMovies!.listMovies
        .where(
          (e) => e.toString().toLowerCase().contains((value.toLowerCase())),
        )
        .toList();
    movies.value = movies.value!.copyWith(listMovies: list);
  } */

  fetch() async {
    var resultEnzymes = await _getEnzymesUseCase();

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
    );
  }
}
