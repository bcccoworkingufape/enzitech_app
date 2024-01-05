// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../shared/ui/ui.dart';
import '../../../../shared/utils/utils.dart';
import '../../../../shared/validator/validator.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../domain/entities/experiment_calculation_entity.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/usecases/calculate_experiment/calculate_experiment_usecase.dart';
import '../../domain/usecases/get_enzymes_remaining_in_experiment/get_enzymes_remaining_in_experiment_usecase.dart';
import '../../domain/usecases/save_result/save_result_usecase.dart';
import '../dto/choosed_experiment_combination_dto.dart';
import '../dto/number_differences_dto.dart';
import 'experiment_details_viewmodel.dart';
import 'experiments_viewmodel.dart';

class CalculateExperimentViewmodel extends ChangeNotifier {
  final CalculateExperimentUseCase _calculateExperimentUseCase;
  final SaveResultUseCase _saveResultUseCase;
  final GetEnzymesRemainingInExperimentUseCase
      _getEnzymesRemainingInExperimentUseCase;

  CalculateExperimentViewmodel(
    this._calculateExperimentUseCase,
    this._saveResultUseCase,
    this._getEnzymesRemainingInExperimentUseCase,
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

  late ExperimentEntity _experiment;
  ExperimentEntity get experiment => _experiment;
  void setExperiment(ExperimentEntity experiment) {
    _experiment = experiment;
  }

  List<EnzymeEntity> _enzymesRemaining = [];
  List<EnzymeEntity> get enzymesRemaining => _enzymesRemaining;
  void setEnzymesRemaining(List<EnzymeEntity> enzymesRemaining) {
    _enzymesRemaining = enzymesRemaining;
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
  void setEnableNextButtonOnFirstStep(
    bool enableNextButtonOnFirstStep, {
    bool notify = true,
  }) {
    _enableNextButtonOnFirstStep = enableNextButtonOnFirstStep;
    if (notify) notifyListeners();
  }

  bool _enableNextButtonOnSecondStep = false;
  bool get enableNextButtonOnSecondStep => _enableNextButtonOnSecondStep;
  void setEnableNextButtonOnSecondStep(
    bool enableNextButtonOnSecondStep, {
    bool notify = true,
  }) {
    _enableNextButtonOnSecondStep = enableNextButtonOnSecondStep;
    if (notify) notifyListeners();
  }

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

  Map<String, TextEditingController> _textEditingControllers = {};
  Map<String, TextEditingController> get textEditingControllers =>
      _textEditingControllers;
  void setTextEditingControllers(
      Map<String, TextEditingController> textEditingControllers) {
    _textEditingControllers = textEditingControllers;
    notifyListeners();
  }

  NumberDifferencesDTO? _numberDifferencesDTO;
  NumberDifferencesDTO? get numberDifferencesDTO => _numberDifferencesDTO;
  void setNumberDifferencesDTO(NumberDifferencesDTO? numberDifferencesDTO) {
    _numberDifferencesDTO = numberDifferencesDTO;
  }

  List<NumberDifferencesDTO?> _listOfNumberDifferencesDTO = [];
  List<NumberDifferencesDTO?> get listOfNumberDifferencesDTO =>
      _listOfNumberDifferencesDTO;
  void setListOfNumberDifferencesDTO(
      List<NumberDifferencesDTO?> listOfNumberDifferencesDTO) {
    _listOfNumberDifferencesDTO = listOfNumberDifferencesDTO;
  }

  bool _alreadyPopped = false;
  bool get alreadyPopped => _alreadyPopped;
  void setAlreadyPopped(bool alreadyPopped) {
    _alreadyPopped = alreadyPopped;
    notifyListeners();
  }

  void onBack(bool mounted, BuildContext context, {int? page}) {
    if (mounted) {
      if (page != null) {
        setAlreadyPopped(false);
        pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      } else {
        {
          if (pageController.page! > 0) {
            setAlreadyPopped(false);
            pageController.animateToPage(
              pageController.page!.toInt() - 1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          } else {
            setEnableNextButtonOnFirstStep(false, notify: false);
            setEnableNextButtonOnSecondStep(false, notify: false);
            setTemporaryChoosedExperimentCombination(
                ChoosedExperimentCombinationDTO());
            setAlreadyPopped(true);
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

  void _validateFields(String value, double id, String type) {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    var b = listOfExperimentData.firstWhere((element) => element["_id"] == id);
    if (value != "") {
      b[type] = double.parse(value);
    }
    if (isAllFilled.every((boolean) => boolean == true)) {
      setEnableNextButtonOnSecondStep(true);
    } else {
      setEnableNextButtonOnSecondStep(false);
    }
  }

  Future<void> generateTextFields(BuildContext context) async {
    setStateEnum(StateEnum.loading);

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
            // print(value);
          },
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
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
            // print(value);
          },
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
        ),
      );
    }
    setStateEnum(StateEnum.idle);
  }

  double _percentOfDifference(num num1, num num2) =>
      (((num2 - num1) / num1) * 100).abs();

  getAbsNumberFartherFromAverage() {
    final average = experimentCalculationEntity!.average.toDouble();

    final results = experimentCalculationEntity!.results;

    double differenceOfFartherNumber =
        _percentOfDifference(average, results.first);

    num fartherNumber = experimentCalculationEntity!.results.first;

    for (var number in results) {
      var diff = _percentOfDifference(average, number);
      if (diff > differenceOfFartherNumber) {
        differenceOfFartherNumber = diff;
        fartherNumber = number;
      }
    }

    setNumberDifferencesDTO(
      NumberDifferencesDTO(
        differenceOfFartherNumber: differenceOfFartherNumber,
        fartherNumber: fartherNumber,
      ),
    );
  }

  calculateListOfNumbersFartherFromAverage() {
    final average = experimentCalculationEntity!.average;

    final results = experimentCalculationEntity!.results;

    var list = <NumberDifferencesDTO>[];

    // double differenceOfFartherNumber =
    //     _percentOfDifference(average, results.first);

    for (var number in results) {
      var diff = _percentOfDifference(average, number);
      var numberWithDifference = NumberDifferencesDTO(
        number: number,
        isFarther: diff > 25,
        differenceOfFartherNumber: diff,
        fartherNumber: 0,
      );
      list.add(numberWithDifference);
      // if (diff > differenceOfFartherNumber) {
      //   differenceOfFartherNumber = diff;
      //   fartherNumber = number;
      // }
    }

    // print(list);

    setListOfNumberDifferencesDTO(list);
  }

  clearTemporaryInfos() {
    setEnableNextButtonOnFirstStep(false, notify: false);
    setEnableNextButtonOnSecondStep(false, notify: false);
    setTemporaryChoosedExperimentCombination(ChoosedExperimentCombinationDTO());
    setExperimentCalculation(null);
    setStateEnum(StateEnum.idle);
    setListOfExperimentData([]);
    setEnzymesRemaining([]);
  }

  Future<void> getEnzymesRemainingInExperiment(String treatmentId) async {
    setStateEnum(StateEnum.loading);

    var result = await _getEnzymesRemainingInExperimentUseCase(
      experimentId: experiment.id,
      treatmentId: treatmentId,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setEnzymesRemaining(success);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> calculateExperiment() async {
    setStateEnum(StateEnum.loading);

    var result = await _calculateExperimentUseCase(
      experimentId: experiment.id,
      enzymeId: temporaryChoosedExperimentCombination.enzyme!.id,
      treatmentID: temporaryChoosedExperimentCombination.treatment!.id,
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

  Future<void> saveResult() async {
    setStateEnum(StateEnum.loading);

    var result = await _saveResultUseCase(
      experimentId: experiment.id,
      enzymeId: temporaryChoosedExperimentCombination.enzyme!.id,
      treatmentID: temporaryChoosedExperimentCombination.treatment!.id,
      listOfExperimentData: listOfExperimentData,
      results: experimentCalculationEntity!.results,
      average: experimentCalculationEntity!.average,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        GetIt.I.get<ExperimentDetailsViewmodel>().setExperiment(success);
        GetIt.I.get<ExperimentsViewmodel>().fetch();
        setStateEnum(StateEnum.success);
      },
    );
  }
}
