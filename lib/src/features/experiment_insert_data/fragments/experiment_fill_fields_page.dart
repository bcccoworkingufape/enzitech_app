// 🐦 Flutter imports:
import 'dart:developer';

import 'package:enzitech_app/src/shared/validator/validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_stepper.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_insert_data/experiment_insert_data_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class ExperimentFillFieldsPage extends StatefulWidget {
  const ExperimentFillFieldsPage({
    Key? key,
    required this.formKey,
  }) : super(key: key);
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<ExperimentFillFieldsPage> createState() =>
      _ExperimentFillFieldsPageState();
}

class _ExperimentFillFieldsPageState extends State<ExperimentFillFieldsPage> {
  late final ExperimentInsertDataController controller;
  late final ExperimentsController experimentsController;

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentInsertDataController>();
    experimentsController = context.read<ExperimentsController>();

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
    Map<String, EZTTextField> filteredMap = Map.from(controller.textFields)
      ..removeWhere((k, v) => !k.toString().contains(mapId));

    var listOfAllTextsOfEnzymes = [];
    filteredMap.forEach((k, v) {
      listOfAllTextsOfEnzymes.add(v.controller!.text);
    });

    if (listOfAllTextsOfEnzymes.isNotEmpty &&
        listOfAllTextsOfEnzymes.sublist(2).any((element) => element.isEmpty)) {
      return true;
    }

    return false;
  }

  bool _isMapCorrectlyFilled(String mapId) {
    Map<String, EZTTextField> filteredMap = Map.from(controller.textFields)
      ..removeWhere((k, v) => !k.toString().contains(mapId));

    var listOfBools = [];
    var listOfBoolsIfAllIsEmpty = [];
    var listOfAllTextsOfEnzymes = [];

    filteredMap.forEach((k, v) {
      listOfBools.add(_checkIfTextIsGTZAndNumeric(v.controller!.text));
      listOfBoolsIfAllIsEmpty.add(v.controller!.text.isEmpty);
      listOfAllTextsOfEnzymes.add(v.controller!.text);
    });

    if (listOfAllTextsOfEnzymes.isNotEmpty &&
        listOfAllTextsOfEnzymes.sublist(2).any((element) => element.isEmpty)) {
      return true;
    }

    if (listOfBoolsIfAllIsEmpty.isNotEmpty &&
        listOfBoolsIfAllIsEmpty
            .sublist(2)
            .every((element) => element == true)) {
      return true;
    }

    return listOfBools.every((b) => b == true);
  }

  EZTStepState _leadWithStepState(Map<String, double?> map) {
    if (controller.stepPage ==
        controller.listOfExperimentData.toList().indexOf(map)) {
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
        Row(
          children: [
            Expanded(
                child: controller.textFields["sample-${map["_id"]}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: controller.textFields["whiteSample-${map["_id"]}"] ??
                    Container()),
          ],
        ),
      ],
    );
  }

  Widget get _body {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: EZTStepper(
        physics: const ClampingScrollPhysics(),
        currentStep: controller.stepPage,
        controlsBuilder: (BuildContext context, EZTControlsDetails details) {
          return Row(
            children: <Widget>[
              /* if (controller.stepPage <
                  Provider.of<CreateExperimentController>(context,
                              listen: false)
                          .experimentRequestModel
                          .experimentsEnzymes
                          .length -
                      1)
                TextButton(
                  onPressed: () {
                    if (controller.stepPage <
                        Provider.of<CreateExperimentController>(context,
                                    listen: false)
                                .experimentRequestModel
                                .experimentsEnzymes
                                .length -
                            1) {
                      controller.setStepPage(controller.stepPage + 1);
                    }
                  },
                  child: const Text('Próximo'),
                ),
              if (controller.stepPage > 0)
                TextButton(
                  onPressed: () {
                    if (controller.stepPage > 0) {
                      controller.setStepPage(controller.stepPage - 1);
                    }
                  },
                  child: const Text('Voltar'),
                ), */
            ],
          );
        },
        onStepTapped: (int index) {
          controller.setStepPage(index);
        },
        type: EZTStepperType.vertical,
        steps: controller.listOfExperimentData.map(
          (map) {
            return EZTStep(
              state: _leadWithStepState(map!),
              title: _isMapCorrectlyFilled(map["_id"].toString())
                  ? Text("Dados da ${map["_id"]!.toInt() + 1}ª repetição")
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
                    visible:
                        controller.textFields["sample-${map["_id"]}"] != null,
                    child: _textFields(map)),
              ),
            );
          },
        ).toList(),
        // key: ValueKey(widget.listOfEnzymes.hashCode),
      ),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: controller.enableNextButton ?? false,
          text: 'Próximo',
          onPressed: () {
            // widget.formKey.currentState!.save();
            controller.insertExperimentData();
            print(controller.choosedEnzymeAndTreatment);

            controller.pageController.animateTo(
              MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            controller.setStepPage(0, notify: false);

            controller.pageController.animateTo(
              0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentInsertDataController>();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Center(child: _body),
          ),
          Expanded(
            flex: 4,
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
