// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/controllers/experiments_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/models/experiment_request_model.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class CreateExperimentViewmodel extends IDisposableProvider {
  final ExperimentsController experimentsController;

  CreateExperimentViewmodel({
    required this.experimentsController,
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

  var experimentCreated = false; //? Remover isso

  PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
  void setPageController(PageController pageController) {
    _pageController = pageController;
    notifyListeners();
  }

  int _stepPage = 0;
  int get stepPage => _stepPage;
  void setStepPage(int stepPage, {bool notify = true}) {
    _stepPage = stepPage;
    if (notify) notifyListeners();
  }

  Map<String, EZTTextField> _textFields = {};
  Map<String, EZTTextField> get textFields => _textFields;
  void setTextFields(Map<String, EZTTextField> textFields) {
    _textFields = textFields;
    notifyListeners();
  }

  ExperimentRequestModel _experimentRequestModel = ExperimentRequestModel(
    name: "",
    description: "",
    repetitions: 0,
    processes: [],
    experimentsEnzymes: [],
  );
  ExperimentRequestModel get experimentRequestModel => _experimentRequestModel;
  void setExperimentRequestModel(
    ExperimentRequestModel experimentRequestModel,
  ) {
    _experimentRequestModel = experimentRequestModel;
    notifyListeners();
  }

  ExperimentEntity? _experiment;
  ExperimentEntity? get experiment => _experiment;
  void setExperiment(ExperimentEntity? experiment) {
    _experiment = experiment;
    notifyListeners();
  }

  Future<void> createExperiment(
    String name,
    String description,
    int repetitions,
    List<String> processes,
    List<EnzymeEntity> experimentsEnzymes,
    Map<String, EZTTextField> textFieldsOfEnzymes,
  ) async {
    setStateEnum(StateEnum.loading);
    try {
      var experiment = await experimentsController.createExperiment(
        name: name,
        description: description,
        repetitions: repetitions,
        processes: processes,
        experimentsEnzymes: experimentsEnzymes,
        textFieldsOfEnzymes: textFieldsOfEnzymes,
      );

      setExperiment(experiment);
      experimentCreated = true;
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
  }
}
