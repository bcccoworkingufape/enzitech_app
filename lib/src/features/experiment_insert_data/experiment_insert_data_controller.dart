// 🐦 Flutter imports:
import 'dart:developer';

import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/validator/validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/services/experiments_service.dart';

enum ExperimentInsertDataState { idle, success, error, loading }

class ExperimentInsertDataController extends ChangeNotifier {
  final ExperimentsService experimentsService;

  ExperimentInsertDataController(
    this.experimentsService,
  );

  var state = ExperimentInsertDataState.idle;

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure failure) {
    _failure = failure;
    notifyListeners();
  }

  late ExperimentModel _experiment;
  ExperimentModel get experiment => _experiment;
  void setExperimentModel(ExperimentModel experiment) {
    _experiment = experiment;
  }

  PageController _pageController = PageController(initialPage: 0);
  PageController get pageController => _pageController;
  void setPageController(PageController pageController) {
    _pageController = pageController;
    notifyListeners();
  }

  Map<String, dynamic> _choosedEnzymeAndTreatment = {
    "process": null,
    "enzyme": null,
    "experimentData": [],
  };
  Map<String, dynamic> get choosedEnzymeAndTreatment =>
      _choosedEnzymeAndTreatment;
  void setChoosedEnzymeAndTreatment(
      Map<String, dynamic> choosedEnzymeAndTreatment) {
    _choosedEnzymeAndTreatment = choosedEnzymeAndTreatment;
  }

  List<Map<String, double?>?> _listOfExperimentData = [];
  List<Map<String, double?>?> get listOfExperimentData => _listOfExperimentData;
  void setListOfExperimentData(
      List<Map<String, double?>?> listOfExperimentData) {
    _listOfExperimentData = listOfExperimentData;
  }

  bool? _enableNextButton;
  bool? get enableNextButton => _enableNextButton;
  void setEnableNextButton(bool? enableNextButton, {bool notify = true}) {
    _enableNextButton = enableNextButton;
    if (notify) notifyListeners();
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

  Map<String, TextEditingController> _textEditingControllers = {};
  Map<String, TextEditingController> get textEditingControllers =>
      _textEditingControllers;
  void setTextEditingControllers(
      Map<String, TextEditingController> textEditingControllers) {
    _textEditingControllers = textEditingControllers;
    notifyListeners();
  }

  Future<void> insertExperimentData(
    String id,
  ) async {
    state = ExperimentInsertDataState.loading;
    // notifyListeners();
    try {
      var experiment = await experimentsService.calculateExperiment(id);
      // _setExperimentModel(experiment);
      state = ExperimentInsertDataState.success;
      notifyListeners();
    } catch (e) {
      _setFailure(e as Failure);
      state = ExperimentInsertDataState.error;
      notifyListeners();
    }
  }

  void generateTextFields(BuildContext context) {
    setTextEditingControllers({});

    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.numeric,
      ),
      ValidateRule(
        ValidateTypes.greaterThanZeroDecimal,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    List<Map<String, double?>?> tempList = [];

    for (var i = 0; i < experiment.repetitions; i++) {
      tempList.add({
        "sample": null,
        "whiteSample": null,
        "_id": i.toDouble(),
      });
    }

    setListOfExperimentData(tempList);

    textEditingControllers.clear();
    textFields.clear();

    for (var i = 0; i < experiment.repetitions; i++) {
      TextEditingController sampleFieldController =
          TextEditingController(text: '');
      textEditingControllers.putIfAbsent(
        'sample-${i.toDouble()}',
        () => sampleFieldController,
      );
      textFields.putIfAbsent(
        'sample-${i.toDouble()}',
        () => EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Amostra",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: sampleFieldController,
          onChanged: (value) => _validateFields,
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
          // disableSuffixIcon: true,
        ),
      );

      TextEditingController whiteSampleFieldController =
          TextEditingController(text: '');
      textEditingControllers.putIfAbsent(
        'whiteSample-${i.toDouble()}',
        () => whiteSampleFieldController,
      );
      textFields.putIfAbsent(
        'whiteSample-${i.toDouble()}',
        () => EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Peso do solo",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: whiteSampleFieldController,
          onChanged: (value) => _validateFields,
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
          // disableSuffixIcon: true,
        ),
      );
    }
    notifyListeners();
  }

  get _validateFields {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    if (/* mounted && */ isAllFilled.every((boolean) => boolean == true)) {
      log(textEditingControllers.toString());
      setEnableNextButton(true);
    } else {
      setEnableNextButton(false);
    }
  }
}
