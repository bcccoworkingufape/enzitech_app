// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../shared/ui/ui.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/repetition_entity.dart';
import '../../domain/usecases/experiments_usecases.dart';
import '../dto/choosed_experiment_combination_dto.dart';
import 'experiment_details_viewmodel.dart';
import 'experiments_viewmodel.dart';

class CalculateExperimentViewmodel extends ChangeNotifier {
  final ExperimentsUseCases _experimentsUseCases;

  CalculateExperimentViewmodel(this._experimentsUseCases);

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
  void setEnableNextButtonOnFirstStep(bool enableNextButtonOnFirstStep, {bool notify = true}) {
    _enableNextButtonOnFirstStep = enableNextButtonOnFirstStep;
    if (notify) notifyListeners();
  }

  ChoosedExperimentCombinationDTO _temporaryChoosedExperimentCombination = ChoosedExperimentCombinationDTO();
  ChoosedExperimentCombinationDTO get temporaryChoosedExperimentCombination => _temporaryChoosedExperimentCombination;
  void setTemporaryChoosedExperimentCombination(ChoosedExperimentCombinationDTO temporaryChoosedExperimentCombination) {
    _temporaryChoosedExperimentCombination = temporaryChoosedExperimentCombination;
    notifyListeners();
  }

  List<RepetitionEntity> _repetitions = [];
  List<RepetitionEntity> get repetitions => _repetitions;
  void setRepetitions(List<RepetitionEntity> repetitions) {
    _repetitions = repetitions;
    notifyListeners();
  }

  // Repetições (slots) de todas as combinações tratamento×enzima escolhidas no primeiro
  // passo. Cada slot pode estar PENDING ou COMPLETED e é salvo de forma isolada, sem
  // depender dos demais — inclusive dos de outras combinações escolhidas ao mesmo tempo.
  List<RepetitionEntity> get repetitionsForChosenCombination {
    final treatmentIds = temporaryChoosedExperimentCombination.treatments.map((t) => t.id).toSet();
    final enzymeIds = temporaryChoosedExperimentCombination.enzymes.map((e) => e.id).toSet();

    if (treatmentIds.isEmpty || enzymeIds.isEmpty) return [];

    final filtered = _repetitions
        .where((repetition) => treatmentIds.contains(repetition.treatmentId) && enzymeIds.contains(repetition.enzymeId))
        .toList();

    filtered.sort((a, b) {
      final treatmentComparison = a.treatmentName.compareTo(b.treatmentName);
      if (treatmentComparison != 0) return treatmentComparison;

      final enzymeComparison = a.enzymeName.compareTo(b.enzymeName);
      if (enzymeComparison != 0) return enzymeComparison;

      return a.repetitionNumber.compareTo(b.repetitionNumber);
    });

    return filtered;
  }

  RepetitionEntity? _previewedRepetition;
  RepetitionEntity? get previewedRepetition => _previewedRepetition;
  void setPreviewedRepetition(RepetitionEntity? previewedRepetition) {
    _previewedRepetition = previewedRepetition;
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
        pageController.animateToPage(page, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
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
            setTemporaryChoosedExperimentCombination(ChoosedExperimentCombinationDTO());
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

    pageController.nextPage(duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
  }

  void clearTemporaryInfos() {
    setEnableNextButtonOnFirstStep(false, notify: false);
    setTemporaryChoosedExperimentCombination(ChoosedExperimentCombinationDTO());
    setRepetitions([]);
    setPreviewedRepetition(null);
    setStateEnum(StateEnum.idle);
  }

  Future<void> fetchRepetitions() async {
    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.getRepetitions(experimentId: experiment.id);

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        setRepetitions(success);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> previewRepetition({
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) async {
    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.previewRepetition(
      experimentId: experiment.id,
      treatmentId: treatmentId,
      enzymeId: enzymeId,
      repetitionNumber: repetitionNumber,
      sample: sample,
      whiteSample: whiteSample,
    );

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) {
        setPreviewedRepetition(success);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> saveRepetition({
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) async {
    setStateEnum(StateEnum.loading);

    var result = await _experimentsUseCases.saveRepetition(
      experimentId: experiment.id,
      treatmentId: treatmentId,
      enzymeId: enzymeId,
      repetitionNumber: repetitionNumber,
      sample: sample,
      whiteSample: whiteSample,
    );

    await result.fold(
      (error) async {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (updatedExperiment) async {
        setExperiment(updatedExperiment);
        GetIt.I.get<ExperimentDetailsViewmodel>().setExperiment(updatedExperiment);
        GetIt.I.get<ExperimentsViewmodel>().fetch();
        setPreviewedRepetition(null);
        await fetchRepetitions();
      },
    );
  }
}
