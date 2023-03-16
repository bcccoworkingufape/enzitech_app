import 'package:flutter/material.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../shared/ui/ui.dart';
import '../../../../shared/utils/utils.dart';
import '../../../../shared/validator/validator.dart';
import '../../domain/entities/experiment_calculation_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/usecases/calculate_experiment/calculate_experiment_usecase.dart';
import '../dto/choosed_experiment_combination_dto.dart';

class CalculateExperimentViewmodel extends ChangeNotifier {
  CalculateExperimentUseCase _calculateExperimentUseCase;

  CalculateExperimentViewmodel(this._calculateExperimentUseCase);

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

  late ExperimentEntity _experiment;
  ExperimentEntity get experiment => _experiment;
  void setExperiment(ExperimentEntity experiment) {
    _experiment = experiment;
  }

  ExperimentCalculationEntity? _experimentCalculationEntity;
  ExperimentCalculationEntity? get experimentCalculationEntity =>
      _experimentCalculationEntity;
  void setExperimentCalculation(
      ExperimentCalculationEntity? experimentCalculationEntity) {
    _experimentCalculationEntity = experimentCalculationEntity;
    notifyListeners();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> firstStepFormKey = GlobalKey<FormState>();

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

  bool _enableNextButtonOnFirstStep = false;
  bool get enableNextButtonOnFirstStep => _enableNextButtonOnFirstStep;
  void setEnableNextButtonOnFirstStep(bool enableNextButtonOnFirstStep) {
    _enableNextButtonOnFirstStep = enableNextButtonOnFirstStep;
    notifyListeners();
  }

  bool _enableNextButtonOnSecondStep = false;
  bool get enableNextButtonOnSecondStep => _enableNextButtonOnSecondStep;
  void setEnableNextButtonOnSecondStep(bool enableNextButtonOnSecondStep) {
    _enableNextButtonOnSecondStep = enableNextButtonOnSecondStep;
    notifyListeners();
  }

  // bool _enableNextButtonOnThirdStep = false;
  // bool get enableNextButtonOnThirdStep => _enableNextButtonOnThirdStep;
  // void setEnableNextButtonOnThirdStep(bool enableNextButtonOnThirdStep) {
  //   _enableNextButtonOnThirdStep = enableNextButtonOnThirdStep;
  //   notifyListeners();
  // }

  // bool _enableNextButtonOnFourthStep = false;
  // bool get enableNextButtonOnFourthStep => _enableNextButtonOnFourthStep;
  // void setEnableNextButtonOnFourthStep(bool enableNextButtonOnFourthStep) {
  //   _enableNextButtonOnFourthStep = enableNextButtonOnFourthStep;
  //   notifyListeners();
  // }

  ChoosedExperimentCombinationDTO _temporaryChoosedExperimentCombination =
      ChoosedExperimentCombinationDTO();
  ChoosedExperimentCombinationDTO get temporaryChoosedExperimentCombination =>
      _temporaryChoosedExperimentCombination;
  void setTemporaryChoosedExperimentCombination(
      ChoosedExperimentCombinationDTO temporaryChoosedExperimentCombination) {
    _temporaryChoosedExperimentCombination =
        temporaryChoosedExperimentCombination;
    notifyListeners();
  }

  List<Map<String, double?>> _listOfExperimentData = [];
  List<Map<String, double?>> get listOfExperimentData => _listOfExperimentData;
  void setListOfExperimentData(
      List<Map<String, double?>> listOfExperimentData) {
    _listOfExperimentData = listOfExperimentData;
  }

  Map<String, EZTTextField> _textFields = {};
  Map<String, EZTTextField> get textFields => _textFields;
  void setTextFields(Map<String, EZTTextField> textFields) {
    _textFields = textFields;
    notifyListeners();
  }

  void onBack(bool mounted, BuildContext context, {int? page}) {
    if (mounted) {
      if (page != null) {
        pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      } else {
        {
          if (pageController.page! > 0) {
            pageController.animateToPage(
              pageController.page!.toInt() - 1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          } else {
            setEnableNextButtonOnFirstStep(false);
            setEnableNextButtonOnSecondStep(false);
            setTemporaryChoosedExperimentCombination(
                ChoosedExperimentCombinationDTO());
            Navigator.pop(context);
          }
        }
      }
    }
  }

  void onNext(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }

    EZTSnackBar.clear(context);

    pageController.nextPage(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
    );
  }

  Map<String, TextEditingController> _textEditingControllers = {};
  Map<String, TextEditingController> get textEditingControllers =>
      _textEditingControllers;
  void setTextEditingControllers(
      Map<String, TextEditingController> textEditingControllers) {
    _textEditingControllers = textEditingControllers;
    notifyListeners();
  }

  void _validateFields(String value, double id, String type) {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    var b = listOfExperimentData.firstWhere((element) => element["_id"] == id);
    if (value != "") {
      b[type] = double.parse(value);
    }
    if (/* mounted && */ isAllFilled.every((boolean) => boolean == true)) {
      // log(textEditingControllers.toString());
      setEnableNextButtonOnSecondStep(true);
    } else {
      setEnableNextButtonOnSecondStep(false);
    }
  }

  Future<void> generateTextFields(BuildContext context) async {
    // state = ExperimentInsertDataState.idle;
    // setIsLoading(true);
    setStateEnum(StateEnum.loading);

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

    List<Map<String, double?>> tempList = [];

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
            print(value);
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
            print(value);
          },
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
          // disableSuffixIcon: true,
        ),
      );
    }
    setStateEnum(StateEnum.idle);
    // setIsLoading(false);

    // notifyListeners();
  }

  Future<void> calculateExperiment() async {
    setStateEnum(StateEnum.loading);

    var result = await _calculateExperimentUseCase(
      enzymeId: temporaryChoosedExperimentCombination.enzymeId!,
      treatmentID: temporaryChoosedExperimentCombination.treatmentId!,
      listOfExperimentData: listOfExperimentData,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setExperimentCalculation(success);
        setStateEnum(StateEnum.success);
      },
    );
  }
}
