// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/enzymes_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

class EnzymesViewmodel extends IDisposableProvider {
  final EnzymesController enzymesController;

  EnzymesViewmodel({
    required this.enzymesController,
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

  List<EnzymeEntity> _enzymes = [];
  List<EnzymeEntity> get enzymes => _enzymes;
  void _setEnzymes(List<EnzymeEntity> treatments) {
    _enzymes = treatments;
    notifyListeners();
  }

  Future<void> loadEnzymes() async {
    setStateEnum(StateEnum.loading);

    try {
      final enzymesList = await enzymesController.getEnzymes();
      _setEnzymes(enzymesList);
      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> deleteEnzyme(String id) async {
    setStateEnum(StateEnum.loading);

    try {
      await enzymesController.deleteEnzyme(id);
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
    //? TODO: test clear _setEnzymes
  }
}
