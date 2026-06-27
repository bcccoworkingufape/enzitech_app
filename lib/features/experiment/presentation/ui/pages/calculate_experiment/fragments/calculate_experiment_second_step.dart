// ðŸ¦ Flutter imports:
import 'package:flutter/material.dart';

// ðŸ“¦ Package imports:
import 'package:get_it/get_it.dart';

// ðŸŒŽ Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/logging/app_logger.dart';
import '../../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../../shared/validator/security_validators.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class CalculateExperimentSecondStepPage extends StatefulWidget {
  const CalculateExperimentSecondStepPage({super.key});

  @override
  State<CalculateExperimentSecondStepPage> createState() => _CalculateExperimentSecondStepPageState();
}

class _CalculateExperimentSecondStepPageState extends State<CalculateExperimentSecondStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
  }

  bool _checkIfTextIsGTZAndNumeric(dynamic text) {
    //* Numeric
    if (text == null) {
      return false;
    }

    if (double.tryParse(text) == null) {
      return false;
    }

    //* GTZ
    var number = double.parse(text);
    if (number <= 0) {
      return false;
    }

    return true;
  }

  bool _isEnzymeStillEmpty(String enzymeId) {
    final sampleController = _calculateExperimentViewmodel.textEditingControllers['sample-$enzymeId'];
    final whiteSampleController = _calculateExperimentViewmodel.textEditingControllers['whiteSample-$enzymeId'];

    if (sampleController == null || whiteSampleController == null) return true;

    return sampleController.text.isEmpty || whiteSampleController.text.isEmpty;
  }

  bool _isEnzymeCorrectlyFilled(String enzymeId) {
    final sampleController = _calculateExperimentViewmodel.textEditingControllers['sample-$enzymeId'];
    final whiteSampleController = _calculateExperimentViewmodel.textEditingControllers['whiteSample-$enzymeId'];

    if (sampleController == null || whiteSampleController == null) return false;

    if (sampleController.text.isEmpty && whiteSampleController.text.isEmpty) {
      return true;
    }

    return _checkIfTextIsGTZAndNumeric(sampleController.text) &&
        _checkIfTextIsGTZAndNumeric(whiteSampleController.text);
  }

  StepState _leadWithStepState(Map<String, double?> map) {
    if (_calculateExperimentViewmodel.stepPage ==
        _calculateExperimentViewmodel.listOfExperimentData.toList().indexOf(map)) {
      return StepState.editing;
    } else if (_isEnzymeStillEmpty(map["_id"].toString())) {
      return StepState.indexed;
    } else if (_isEnzymeCorrectlyFilled(map["_id"].toString())) {
      return StepState.complete;
    } else {
      return StepState.error;
    }
  }

  Widget _textFields(Map<String, double?> map) {
    final validations = SecurityValidators.absorbance();
    final fieldValidator = FieldValidator(validations, context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.sample,
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _calculateExperimentViewmodel.textEditingControllers["sample-${map["_id"]}"]!,
          onChanged: (value) {
            _calculateExperimentViewmodel.validateFields(value, map["_id"] as double, "sample");
          },
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.whiteSample,
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          controller: _calculateExperimentViewmodel.textEditingControllers["whiteSample-${map["_id"]}"]!,
          onChanged: (value) {
            _calculateExperimentViewmodel.validateFields(value, map["_id"] as double, "whiteSample");
          },
          fieldValidator: fieldValidator,
          inputFormatters: Constants.enzymeDecimalInputFormatters,
        ),
      ],
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnSecondStep,
          text: context.l10n.calculateButton,
          loading: _calculateExperimentViewmodel.state == StateEnum.loading,
          onPressed: () async {
            if (_calculateExperimentViewmodel.formKey.currentState != null) {
              _calculateExperimentViewmodel.formKey.currentState!.save();

              if (_calculateExperimentViewmodel.formKey.currentState!.validate()) {
                await _calculateExperimentViewmodel.calculateExperiment().whenComplete(() {
                  if (!mounted) return;
                  (_calculateExperimentViewmodel.experimentCalculationEntity != null &&
                          _calculateExperimentViewmodel.experimentCalculationEntity?.average != 0)
                      ? _calculateExperimentViewmodel.onNext(context)
                      : AppLogger.warn('Experiment calculation returned zero average; user-visible error suppressed.');
                });
                //TODO: Corrigir enzimas bugadas (sem calculo -> retorno 0)

                return;
              }
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: context.l10n.backButton,
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            _calculateExperimentViewmodel.onBack(mounted, context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _calculateExperimentViewmodel,
      builder: (context, child) {
        return CalculateExperimentFragmentTemplate(
          titleOfStepIndicator: context.l10n.insertExperimentData,
          messageOfStepIndicator: context.l10n.stepIndicatorMessageFilling(2, 3),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                SingleChildScrollView(
                  child: Stepper(
                    physics: const ClampingScrollPhysics(),
                    currentStep: _calculateExperimentViewmodel.stepPage,
                    controlsBuilder: (BuildContext context, ControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          if (_calculateExperimentViewmodel.stepPage <
                              _calculateExperimentViewmodel.experiment.repetitions - 1)
                            TextButton(
                              onPressed: () {
                                if (_calculateExperimentViewmodel.stepPage <
                                    _calculateExperimentViewmodel.experiment.repetitions) {
                                  _calculateExperimentViewmodel.setStepPage(_calculateExperimentViewmodel.stepPage + 1);
                                }
                              },
                              child: Text(context.l10n.nextButton),
                            ),
                          if (_calculateExperimentViewmodel.stepPage > 0)
                            TextButton(
                              onPressed: () {
                                if (_calculateExperimentViewmodel.stepPage > 0) {
                                  _calculateExperimentViewmodel.setStepPage(_calculateExperimentViewmodel.stepPage - 1);
                                }
                              },
                              child: Text(context.l10n.backButton),
                            ),
                        ],
                      );
                    },
                    onStepTapped: (int index) {
                      _calculateExperimentViewmodel.setStepPage(index);
                    },
                    type: StepperType.vertical,
                    steps: _calculateExperimentViewmodel.listOfExperimentData.map((map) {
                      return Step(
                        state: _leadWithStepState(map),
                        title: _isEnzymeCorrectlyFilled(map["_id"].toString())
                            ? Text(context.l10n.repetitionDataTitle(map["_id"]!.toInt() + 1))
                            : Text(
                                "âš   ${context.l10n.repetitionDataTitle(map["_id"]!.toInt() + 1)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.getApplyedColorScheme.error,
                                ),
                              ),
                        content: Visibility(
                          visible: _calculateExperimentViewmodel.textEditingControllers["sample-${map["_id"]}"] != null,
                          child: _textFields(map),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 64),
                _buttons,
              ],
            ),
          ),
        );
      },
    );
  }
}


