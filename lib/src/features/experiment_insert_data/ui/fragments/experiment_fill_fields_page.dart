// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/ui/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/viewmodel/experiment_insert_data_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class ExperimentFillFieldsPage extends StatefulWidget {
  const ExperimentFillFieldsPage({
    Key? key,
    // required this.formKey,
    required this.callback,
  }) : super(key: key);
  // final GlobalKey<FormBuilderState> formKey;
  final void Function({int page}) callback;

  @override
  State<ExperimentFillFieldsPage> createState() =>
      _ExperimentFillFieldsPageState();
}

class _ExperimentFillFieldsPageState extends State<ExperimentFillFieldsPage> {
  late final ExperimentInsertDataViewmodel viewmodel;
  late final ExperimentsViewmodel experimentsViewmodel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<ExperimentInsertDataViewmodel>();
    experimentsViewmodel = context.read<ExperimentsViewmodel>();

    /* if (mounted) {
      controller.addListener(
        () {
          if (mounted && controller.state == ExperimentInsertDataState.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    } */
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
    Map<String, EZTTextField> filteredMap = Map.from(viewmodel.textFields)
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
    Map<String, EZTTextField> filteredMap = Map.from(viewmodel.textFields)
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
    if (viewmodel.stepPage ==
        viewmodel.listOfExperimentData.toList().indexOf(map)) {
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
        viewmodel.textFields["sample-${map["_id"]}"] ?? Container(),
        const SizedBox(width: 10),
        viewmodel.textFields["whiteSample-${map["_id"]}"] ?? Container(),
      ],
    );
  }

  Widget get _body {
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
                  currentStep: viewmodel.stepPage,
                  controlsBuilder:
                      (BuildContext context, EZTControlsDetails details) {
                    return Row(
                      children: <Widget>[
                        if (viewmodel.stepPage <
                            viewmodel.experiment.repetitions - 1)
                          TextButton(
                            onPressed: () {
                              if (viewmodel.stepPage <
                                  viewmodel.experiment.repetitions) {
                                viewmodel.setStepPage(viewmodel.stepPage + 1);
                              }
                            },
                            child: const Text('Próximo'),
                          ),
                        if (viewmodel.stepPage > 0)
                          TextButton(
                            onPressed: () {
                              if (viewmodel.stepPage > 0) {
                                viewmodel.setStepPage(viewmodel.stepPage - 1);
                              }
                            },
                            child: const Text('Voltar'),
                          ),
                      ],
                    );
                  },
                  onStepTapped: (int index) {
                    viewmodel.setStepPage(index);
                  },
                  type: EZTStepperType.vertical,
                  steps: viewmodel.listOfExperimentData.map(
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
                              visible: viewmodel
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
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: viewmodel.enableNextButton ?? false,
          text: 'Próximo',
          loading: viewmodel.state == StateEnum.loading ? true : false,
          onPressed: () async {
            if (_formKey.currentState != null) {
              _formKey.currentState!.save();

              if (_formKey.currentState!.validate()) {
                if (mounted) {
                  // widget.formKey.currentState!.save();
                  await viewmodel.insertExperimentData();

                  viewmodel.pageController.animateTo(
                    MediaQuery.of(context).size.width,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                  );
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
            widget.callback(page: 0);
            _formKey.currentState?.reset();
            viewmodel.setStepPage(0, notify: false);
            viewmodel.setEnableNextButton(null);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentInsertDataViewmodel>();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Center(child: _body),
          ),
          SizedBox(
            height: 144,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: Constants.padding16all,
                child: _buttons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
