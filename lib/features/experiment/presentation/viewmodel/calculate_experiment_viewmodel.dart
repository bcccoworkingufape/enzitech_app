import 'package:flutter/material.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
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

  // int _stepPage = 0;
  // int get stepPage => _stepPage;
  // void setStepPage(int stepPage, {bool notify = true}) {
  //   _stepPage = stepPage;
  //   if (notify) notifyListeners();
  // }

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

  // Map<String, EZTTextField> _textFields = {};
  // Map<String, EZTTextField> get textFields => _textFields;
  // void setTextFields(Map<String, EZTTextField> textFields) {
  //   _textFields = textFields;
  //   notifyListeners();
  // }

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

    pageController.nextPage(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
    );
  }

  Future<void> calculateExperiment() async {
    setStateEnum(StateEnum.loading);

    /* try {
      var enzymes = temporaryExperiment.enzymes!
          .map(
            (enzyme) => EnzymeDto.toExperimetEnzyme(
              enzyme,
              duration: int.parse(
                  textFields['duration-${enzyme.id}']!.controller!.text),
              weightSample: double.parse(
                  textFields['weightSample-${enzyme.id}']!.controller!.text),
              weightGround: double.parse(
                  textFields['weightGround-${enzyme.id}']!.controller!.text),
              size: double.parse(
                  textFields['size-${enzyme.id}']!.controller!.text),
            ),
          )
          .toList();

      setTemporaryExperiment(
        CreateExperimentDTO(
          name: temporaryExperiment.name,
          description: temporaryExperiment.description,
          enzymes: enzymes,
          repetitions: temporaryExperiment.repetitions,
          treatmentsIDs: temporaryExperiment.treatmentsIDs,
        ),
      );
    } on Exception catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
      return;
    } */

    var result = await _calculateExperimentUseCase(
      enzymeId: '',
      treatmentID: '',
      experimentData: {},
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
