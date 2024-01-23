// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/inject/inject.dart';
import '../../../../shared/ui/ui.dart';
import '../../../enzyme/data/dto/enzyme_dto.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/usecases/create_experiment/create_experiment_usecase.dart';
import '../dto/create_experiment_dto.dart';
import 'experiments_viewmodel.dart';

class CreateExperimentViewmodel extends ChangeNotifier {
  final CreateExperimentUseCase _createExperimentUseCase;
  final ExperimentsViewmodel _experimentsViewmodel;

  CreateExperimentViewmodel(
    this._createExperimentUseCase,
    this._experimentsViewmodel,
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

  ExperimentEntity? _experiment;
  ExperimentEntity? get experiment => _experiment;
  void setExperiment(ExperimentEntity? experiment) {
    _experiment = experiment;
    notifyListeners();
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
  void setTemporaryExperiment(CreateExperimentDTO temporaryExperiment) {
    _temporaryExperiment = temporaryExperiment;
    notifyListeners();
  }

  Map<String, EZTTextField> _textFields = {};
  Map<String, EZTTextField> get textFields => _textFields;
  void setTextFields(Map<String, EZTTextField> textFields) {
    _textFields = textFields;
    notifyListeners();
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
            setTemporaryExperiment(CreateExperimentDTO());
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

    pageController.nextPage(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeIn,
    );
  }

  Future<void> createExperiment() async {
    setStateEnum(StateEnum.loading);

    try {
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
    }

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
        setExperiment(success);
        await _experimentsViewmodel.fetch(); // reload the experiments list
        setStateEnum(StateEnum.success);
      },
    );
  }
}
