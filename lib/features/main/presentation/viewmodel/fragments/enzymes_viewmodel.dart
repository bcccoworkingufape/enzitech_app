// import 'package:enzitech_app/features/home/data/datasources/get_enzymes_datasource.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../core/enums/enums.dart';
import '../../../../../core/failures/failures.dart';
import '../../../domain/entities/enzyme_entity.dart';
import '../../../domain/usecases/delete_enzyme/delete_enzyme_usecase.dart';
import '../../../domain/usecases/get_enzymes/get_enzymes_usecase.dart';

class EnzymesViewmodel extends ChangeNotifier {
  final GetEnzymesUseCase _getEnzymesUseCase;
  final DeleteEnzymeUseCase _deleteEnzymeUseCase;

  EnzymesViewmodel(
    this._getEnzymesUseCase,
    this._deleteEnzymeUseCase,
  );

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

  List<EnzymeEntity> _enzymes = [];
  List<EnzymeEntity> get enzymes => _enzymes;
  void _setEnzymes(List<EnzymeEntity> treatments) {
    _enzymes = treatments;
    notifyListeners();
  }

  Future<void> fetch() async {
    setStateEnum(StateEnum.loading);

    var result = await _getEnzymesUseCase();

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        _setEnzymes(success);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> deleteEnzyme(String id) async {
    var result = await _deleteEnzymeUseCase(id);

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {},
    );
  }
}
