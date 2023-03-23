// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class CalculateExperimentSecondStepPage extends StatefulWidget {
  const CalculateExperimentSecondStepPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CalculateExperimentSecondStepPage> createState() =>
      _CalculateExperimentSecondStepPageState();
}

class _CalculateExperimentSecondStepPageState
    extends State<CalculateExperimentSecondStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
  }

  bool _checkIfTextIsGTZAndNumeric(text) {
    // Numeric
    if (text == null) {
      return false;
    }

    if (double.tryParse(text) == null) {
      return false;
    }

    // GTZ
    var number = double.parse(text);
    if (number <= 0) {
      return false;
    }

    return true;
  }

  bool _isMapStillEmpty(String mapId) {
    Map<String, EZTTextField> filteredMap =
        Map.from(_calculateExperimentViewmodel.textFields)
          ..removeWhere((k, v) => !k.toString().contains(mapId));

    var listOfAllTextsOfData = [];
    filteredMap.forEach((k, v) {
      listOfAllTextsOfData.add(v.controller!.text);
    });

    if (listOfAllTextsOfData.isNotEmpty &&
        listOfAllTextsOfData.any((element) => element.isEmpty)) {
      return true;
    }

    return false;
  }

  bool _isMapCorrectlyFilled(String mapId) {
    Map<String, EZTTextField> filteredMap =
        Map.from(_calculateExperimentViewmodel.textFields)
          ..removeWhere((k, v) => !k.toString().contains(mapId));

    var listOfBools = [];
    var listOfBoolsIfAllIsEmpty = [];
    var listOfAllTextsOfData = [];

    filteredMap.forEach((k, v) {
      listOfBools.add(_checkIfTextIsGTZAndNumeric(v.controller!.text));
      listOfBoolsIfAllIsEmpty.add(v.controller!.text.isEmpty);
      listOfAllTextsOfData.add(v.controller!.text);
    });

    if (listOfAllTextsOfData.isNotEmpty &&
        listOfAllTextsOfData.any((element) => element.isEmpty)) {
      return true;
    }

    if (listOfBoolsIfAllIsEmpty.isNotEmpty &&
        listOfBoolsIfAllIsEmpty.every((element) => element == true)) {
      return true;
    }

    return listOfBools.every((b) => b == true);
  }

  EZTStepState _leadWithStepState(Map<String, double?> map) {
    if (_calculateExperimentViewmodel.stepPage ==
        _calculateExperimentViewmodel.listOfExperimentData
            .toList()
            .indexOf(map)) {
      return EZTStepState.editing;
    } else if (_isMapStillEmpty(map["_id"].toString())) {
      return EZTStepState.indexed;
    } else if (_isMapCorrectlyFilled(map["_id"].toString())) {
      return EZTStepState.complete;
    } else {
      return EZTStepState.error;
    }
  }

  Widget _textFields(Map<String, double?> map) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _calculateExperimentViewmodel.textFields["sample-${map["_id"]}"] ??
            Container(),
        const SizedBox(width: 10),
        _calculateExperimentViewmodel.textFields["whiteSample-${map["_id"]}"] ??
            Container(),
      ],
    );
  }

  /* Widget get _body {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const EZTCreateExperimentStepIndicator(
              title: "Inserir dados no experimento",
              message: "Etapa 2 de 2 - Inserção de dados",
            ),
            const SizedBox(
              height: 64,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: EZTStepper(
                  physics: const ClampingScrollPhysics(),
                  currentStep: _calculateExperimentViewmodel.stepPage,
                  controlsBuilder:
                      (BuildContext context, EZTControlsDetails details) {
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
                            child: const Text('Próximo'),
                          ),
                        if (_calculateExperimentViewmodel.stepPage > 0)
                          TextButton(
                            onPressed: () {
                              if (_calculateExperimentViewmodel.stepPage > 0) {
                                _calculateExperimentViewmodel.setStepPage(_calculateExperimentViewmodel.stepPage - 1);
                              }
                            },
                            child: const Text('Voltar'),
                          ),
                      ],
                    );
                  },
                  onStepTapped: (int index) {
                    _calculateExperimentViewmodel.setStepPage(index);
                  },
                  type: EZTStepperType.vertical,
                  steps: _calculateExperimentViewmodel.listOfExperimentData.map(
                    (map) {
                      return EZTStep(
                        state: _leadWithStepState(map!),
                        title: _isMapCorrectlyFilled(map["_id"].toString())
                            ? Text(
                                "Dados da ${map["_id"]!.toInt() + 1}ª repetição")
                            : Text(
                                "⚠  Dados da ${map["_id"]!.toInt() + 1}ª repetição",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.danger,
                                ),
                              ),
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Visibility(
                              visible: _calculateExperimentViewmodel
                                      .textFields["sample-${map["_id"]}"] !=
                                  null,
                              child: _textFields(map)),
                        ),
                      );
                    },
                  ).toList(),
                  // key: ValueKey(widget.listOfEnzymes.hashCode),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  } */

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnSecondStep,
          text: 'Calcular',
          loading: _calculateExperimentViewmodel.state == StateEnum.loading,
          onPressed: () async {
            print(_calculateExperimentViewmodel.listOfExperimentData);
            if (_calculateExperimentViewmodel.formKey.currentState != null) {
              _calculateExperimentViewmodel.formKey.currentState!.save();

              if (_calculateExperimentViewmodel.formKey.currentState!
                  .validate()) {
                if (mounted) {
                  // widget.formKey.currentState!.save();
                  // await _calculateExperimentViewmodel.insertExperimentData();
                  await _calculateExperimentViewmodel
                      .calculateExperiment()
                      .whenComplete(() => (_calculateExperimentViewmodel
                                      .experimentCalculationEntity !=
                                  null ||
                              _calculateExperimentViewmodel
                                      .experimentCalculationEntity?.average !=
                                  0)
                          ? _calculateExperimentViewmodel.onNext(context)
                          : print('err'));
                  //TODO: Corrgiri enzimas bugadas (sem calculo -> retorno 0)
                }

                return;
              }
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
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
    return AnimatedBuilder(
        animation: _calculateExperimentViewmodel,
        builder: (context, child) {
          return CalculateExperimentFragmentTemplate(
            titleOfStepIndicator: "Inserir dados no experimento",
            messageOfStepIndicator: "Etapa 2 de 3 - Preenchimento e cálculo",
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),
                  SingleChildScrollView(
                    child: EZTStepper(
                      physics: const ClampingScrollPhysics(),
                      currentStep: _calculateExperimentViewmodel.stepPage,
                      controlsBuilder:
                          (BuildContext context, EZTControlsDetails details) {
                        return Row(
                          children: <Widget>[
                            if (_calculateExperimentViewmodel.stepPage <
                                _calculateExperimentViewmodel
                                        .experiment.repetitions -
                                    1)
                              TextButton(
                                onPressed: () {
                                  if (_calculateExperimentViewmodel.stepPage <
                                      _calculateExperimentViewmodel
                                          .experiment.repetitions) {
                                    _calculateExperimentViewmodel.setStepPage(
                                        _calculateExperimentViewmodel.stepPage +
                                            1);
                                  }
                                },
                                child: const Text('Próximo'),
                              ),
                            if (_calculateExperimentViewmodel.stepPage > 0)
                              TextButton(
                                onPressed: () {
                                  if (_calculateExperimentViewmodel.stepPage >
                                      0) {
                                    _calculateExperimentViewmodel.setStepPage(
                                        _calculateExperimentViewmodel.stepPage -
                                            1);
                                  }
                                },
                                child: const Text('Voltar'),
                              ),
                          ],
                        );
                      },
                      onStepTapped: (int index) {
                        _calculateExperimentViewmodel.setStepPage(index);
                      },
                      type: EZTStepperType.vertical,
                      steps: _calculateExperimentViewmodel.listOfExperimentData
                          .map(
                        (map) {
                          return EZTStep(
                            state: _leadWithStepState(map),
                            title: _isMapCorrectlyFilled(map["_id"].toString())
                                ? Text(
                                    "Dados da ${map["_id"]!.toInt() + 1}ª repetição")
                                : Text(
                                    "⚠  Dados da ${map["_id"]!.toInt() + 1}ª repetição",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.danger,
                                    ),
                                  ),
                            content: Container(
                              alignment: Alignment.centerLeft,
                              child: Visibility(
                                  visible: _calculateExperimentViewmodel
                                          .textFields["sample-${map["_id"]}"] !=
                                      null,
                                  child: _textFields(map)),
                            ),
                          );
                        },
                      ).toList(),
                      // key: ValueKey(widget.listOfEnzymes.hashCode),
                    ),
                  ),
                  const SizedBox(
                    height: 64,
                  ),
                  _buttons,
                ],
              ),
            ),
          );
        });
  }
}
