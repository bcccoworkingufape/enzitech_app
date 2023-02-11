// import 'package:enzitech_app/features/home/data/datasources/get_enzymes_datasource.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/enzyme_entity.dart';
import '../../domain/usecases/get_enzymes/get_enzymes_usecase.dart';

class SplashViewmodel extends ChangeNotifier {
  final GetEnzymesUseCase _getEnzymesUseCase;
  SplashViewmodel(this._getEnzymesUseCase) {
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

  List<EnzymeEntity>? _enzymes;
  List<EnzymeEntity>? get enzymes => _enzymes;
  void setEnzymes(List<EnzymeEntity>? state) {
    _enzymes = enzymes;
    notifyListeners();
  }

  List<EnzymeEntity>? _cachedEnzymes;

  /* onChanged(String value) {
    List<MovieDetailsEntity> list = _cachedMovies!.listMovies
        .where(
          (e) => e.toString().toLowerCase().contains((value.toLowerCase())),
        )
        .toList();
    movies.value = movies.value!.copyWith(listMovies: list);
  } */

  fetch() async {
    // try {
    var result = await _getEnzymesUseCase();

    result.fold(
      (error) {
        print('-> SETOU DENTRO');
        _setFailure(error);
        setStateEnum(StateEnum.error);
        // throw error;
      },
      (success) {
        setEnzymes(success);
        setStateEnum(StateEnum.success);
      },
    );

    // } catch (e) {
    //   print('-> SETOU FORA');

    //   _setFailure(e as Failure);
    //   setStateEnum(StateEnum.error);
    // }

    // print('chamou');
    // var result = await _getEnzymesUseCase();
    // print('result > $result');

    // result.fold(
    //   (error) => debugPrint(error.toString()),
    //   (success) => setEnzymes(success),
    // );

    // _cachedEnzymes = enzymes;
  }
}
