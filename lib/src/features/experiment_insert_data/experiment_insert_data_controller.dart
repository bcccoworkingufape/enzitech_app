// 🐦 Flutter imports:

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

  ExperimentInsertDataState _state = ExperimentInsertDataState.idle;
  ExperimentInsertDataState get state => _state;
  void _setState(ExperimentInsertDataState state) {
    _state = state;
    notifyListeners();
  }

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

  /* bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setIsLoading(bool isLoading, {bool notify = true}) {
    _isLoading = isLoading;
    if (notify) notifyListeners();
  } */

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

  Future<void> insertExperimentData() async {
    _setState(ExperimentInsertDataState.loading);
    try {
      _createCalculateJson();
      var a = await experimentsService
          .calculateExperiment(choosedEnzymeAndTreatment);
      _setState(ExperimentInsertDataState.success);
    } catch (e) {
      _setFailure(e as Failure);
      _setState(ExperimentInsertDataState.error);
    }
  }

  Future<void> generateTextFields(BuildContext context) async {
    // state = ExperimentInsertDataState.idle;
    // setIsLoading(true);
    _setState(ExperimentInsertDataState.loading);

    // await Future.delayed(Duration.zero);

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

    for (var i = 0; i < listOfExperimentData.length; i++) {
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
          onChanged: (value) {
            _validateFields(value, i.toDouble(), "sample");
          },
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
          labelText: "Amostra branca",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: whiteSampleFieldController,
          onChanged: (value) {
            _validateFields(value, i.toDouble(), "whiteSample");
          },
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
          // disableSuffixIcon: true,
        ),
      );
    }
    _setState(ExperimentInsertDataState.idle);
    // setIsLoading(false);

    // notifyListeners();
  }

  void _createCalculateJson() {
    /* List<Map<String, double?>?> tempListOfData = [];
    tempListOfData.addAll(listOfExperimentData);

    for (var element in tempListOfData) {
      element!.removeWhere((key, value) => key == "_id");
    } */

    Map<String, dynamic> tempMap = Map.from(choosedEnzymeAndTreatment);

    tempMap["experimentData"] = listOfExperimentData;

    setChoosedEnzymeAndTreatment(tempMap);
  }

  void _validateFields(String value, double id, String type) {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    var b = listOfExperimentData.firstWhere((element) => element!["_id"] == id);
    if (value != "") {
      b![type] = double.parse(value);
    }
    if (/* mounted && */ isAllFilled.every((boolean) => boolean == true)) {
      // log(textEditingControllers.toString());
      setEnableNextButton(true);
    } else {
      setEnableNextButton(false);
    }
  }
}
