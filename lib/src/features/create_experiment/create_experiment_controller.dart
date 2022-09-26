// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';
import '../../shared/models/experiment_request_model.dart';
import '../../shared/widgets/ezt_textfield.dart';

enum CreateExperimentState { idle, success, error, loading }

class CreateExperimentController extends ChangeNotifier {
  final ExperimentsService experimentService;

  CreateExperimentController(this.experimentService);

  var state = CreateExperimentState.idle;
  var experimentCreated = false;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

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

  ExperimentModel? _experimentModel;
  ExperimentModel? get experimentModel => _experimentModel;
  void setExperimentModel(
    ExperimentModel? experimentModel,
  ) {
    _experimentModel = experimentModel;
    notifyListeners();
  }

  List<EnzymeModel> _enzymes = [];
  List<EnzymeModel> get enzymes => _enzymes;
  void _setEnzymes(List<EnzymeModel> enzymes) {
    _enzymes = enzymes;
    notifyListeners();
  }

  Future<void> loadEnzymes() async {
    state = CreateExperimentState.loading;
    notifyListeners();
    try {
      final enzymesList = await experimentService.fetchEnzymes();
      _setEnzymes(enzymesList);

      state = CreateExperimentState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = CreateExperimentState.error;
      notifyListeners();
    }
  }

  Future<void> createExperiment(
    String name,
    String description,
    int repetitions,
    List<String> processes,
    List<EnzymeModel> experimentsEnzymes,
    Map<String, EZTTextField> textFieldsOfEnzymes,
  ) async {
    state = CreateExperimentState.loading;
    notifyListeners();
    try {
      var experiment = await experimentService.createExperiment(
        name,
        description,
        repetitions,
        processes,
        experimentsEnzymes,
        textFieldsOfEnzymes,
      );

      state = CreateExperimentState.success;
      experimentCreated = true;
      setExperimentModel(experiment);
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = CreateExperimentState.error;
      notifyListeners();
    }
  }
}
