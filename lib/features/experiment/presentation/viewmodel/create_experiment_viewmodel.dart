import 'package:flutter/material.dart';

import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/usecases/create_experiment/create_experiment_usecase.dart';
import '../dto/create_experiment_dto.dart';

class CreateExperimentViewmodel extends ChangeNotifier {
  CreateExperimentUseCase _createExperimentUseCase;

  CreateExperimentViewmodel(this._createExperimentUseCase);

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

  // var experimentCreated = false; //? Remover isso
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  bool _enableNextButtonOnThirdStep = false;
  bool get enableNextButtonOnThirdStep => _enableNextButtonOnThirdStep;
  void setEnableNextButtonOnThirdStep(bool enableNextButtonOnThirdStep) {
    _enableNextButtonOnThirdStep = enableNextButtonOnThirdStep;
    notifyListeners();
  }

  bool _enableNextButtonOnFourthStep = false;
  bool get enableNextButtonOnFourthStep => _enableNextButtonOnFourthStep;
  void setEnableNextButtonOnFourthStep(bool enableNextButtonOnFourthStep) {
    _enableNextButtonOnFourthStep = enableNextButtonOnFourthStep;
    notifyListeners();
  }

  CreateExperimentDTO _temporaryExperiment = CreateExperimentDTO();
  CreateExperimentDTO get temporaryExperiment => _temporaryExperiment;
  void setCreateExperimentDTO(CreateExperimentDTO temporaryExperiment) {
    _temporaryExperiment = temporaryExperiment;
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
            setCreateExperimentDTO(CreateExperimentDTO());
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

    pageController.animateTo(
      MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
    );
  }

  Future<void> createExperiment() async {
    setStateEnum(StateEnum.loading);

    var result = await _createExperimentUseCase(
      name: _temporaryExperiment.name!,
      description: _temporaryExperiment.description!,
      repetitions: _temporaryExperiment.repetitions!,
      treatmentsIDs: _temporaryExperiment.treatmentsIDs!,
      enzymes: _temporaryExperiment.enzymes!,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        // _setExperiment(success);
        setStateEnum(StateEnum.success);
      },
    );
  }
}
