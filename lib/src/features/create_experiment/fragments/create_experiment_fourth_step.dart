// ignore_for_file: avoid_function_literals_in_foreach_calls

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/shared/models_/enzyme_model.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/utilities/util/constants.dart';
import 'package:enzitech_app/src/shared/utilities/validator/field_validator.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_stepper.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_textfield.dart';

// TODO: Verify dispose error
class CreateExperimentFourthStepPage extends StatefulWidget {
  const CreateExperimentFourthStepPage({
    Key? key,
    required this.formKey,
    required this.listOfEnzymes,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final List<EnzymeModel> listOfEnzymes;

  @override
  State<CreateExperimentFourthStepPage> createState() =>
      _CreateExperimentFourthStepPageState();
}

class _CreateExperimentFourthStepPageState
    extends State<CreateExperimentFourthStepPage> {
  late final CreateExperimentController controller;

  Map<String, TextEditingController> textEditingControllers = {};

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

  bool enableNextButton = false;

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();

    Future.delayed(const Duration(milliseconds: 0)).whenComplete(() {
      if (mounted) {
        controller.setStepPage(0, notify: false);

        final fieldValidator = FieldValidator(validations, context);

        setState(() {
          textEditingControllers.clear();
          controller.textFields.clear();

          controller.experimentRequestModel.experimentsEnzymes
              .forEach((enzyme) {
            TextEditingController aFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'aVariable-${enzyme.id}',
              () => aFieldController,
            );
            controller.textFields.putIfAbsent('aVariable-${enzyme.id}', () {
              aFieldController.text = enzyme.variableA.toString();
              return EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Variável A",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: aFieldController,
                enabled: false,
                onChanged: (value) => _validateFields,
                fieldValidator: fieldValidator,
                inputFormatters: Constants.enzymeDecimalInputFormatters,
                // disableSuffixIcon: true,
              );
            });

            TextEditingController bFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'bVariable-${enzyme.id}',
              () => bFieldController,
            );
            controller.textFields.putIfAbsent(
              'bVariable-${enzyme.id}',
              () {
                bFieldController.text = enzyme.variableB.toString();
                return EZTTextField(
                  eztTextFieldType: EZTTextFieldType.underline,
                  labelText: "Variável B",
                  usePrimaryColorOnFocusedBorder: true,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: bFieldController,
                  enabled: false,
                  onChanged: (value) => _validateFields,
                  fieldValidator: fieldValidator,
                  inputFormatters: Constants.enzymeDecimalInputFormatters,
                  // disableSuffixIcon: true,
                );
              },
            );

            TextEditingController durationFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'duration-${enzyme.id}',
              () => durationFieldController,
            );
            controller.textFields.putIfAbsent(
              'duration-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Duração",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: durationFieldController,
                onChanged: (value) => _validateFields,
                fieldValidator: fieldValidator,
                inputFormatters: Constants.enzymeDecimalInputFormatters,
                // disableSuffixIcon: true,
              ),
            );

            TextEditingController sizeFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'size-${enzyme.id}',
              () => sizeFieldController,
            );
            controller.textFields.putIfAbsent(
              'size-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Volume",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: sizeFieldController,
                onChanged: (value) => _validateFields,
                fieldValidator: fieldValidator,
                inputFormatters: Constants.enzymeDecimalInputFormatters,
                // disableSuffixIcon: true,
              ),
            );

            TextEditingController weightSampleFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'weightSample-${enzyme.id}',
              () => weightSampleFieldController,
            );
            controller.textFields.putIfAbsent(
              'weightSample-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Peso da amostra",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: weightSampleFieldController,
                onChanged: (value) => _validateFields,
                fieldValidator: fieldValidator,
                inputFormatters: Constants.enzymeDecimalInputFormatters,
                // disableSuffixIcon: true,
              ),
            );

            TextEditingController weightGroundFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'weightGround-${enzyme.id}',
              () => weightGroundFieldController,
            );
            controller.textFields.putIfAbsent(
              'weightGround-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Peso do solo",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: weightGroundFieldController,
                onChanged: (value) => _validateFields,
                fieldValidator: fieldValidator,
                inputFormatters: Constants.enzymeDecimalInputFormatters,
                // disableSuffixIcon: true,
              ),
            );
            // return;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    try {
      textEditingControllers.forEach((_, tec) {
        tec.dispose();
      });
    } catch (e) {
      // DO NOTHING
    }
    super.dispose();
  }

  get _validateFields {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    if (mounted && isAllFilled.every((boolean) => boolean == true)) {
      setState(() {
        enableNextButton = true;
      });
    } else {
      setState(() {
        enableNextButton = false;
      });
    }
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

  bool _isEnzymeStillEmpty(String enzymeId) {
    Map<String, EZTTextField> filteredMap = Map.from(controller.textFields)
      ..removeWhere((k, v) => !k.toString().contains(enzymeId));

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

  bool _isEnzymeCorrectlyFilled(String enzymeId) {
    Map<String, EZTTextField> filteredMap = Map.from(controller.textFields)
      ..removeWhere((k, v) => !k.toString().contains(enzymeId));

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

  EZTStepState _leadWithStepState(EnzymeModel enzyme) {
    if (controller.stepPage ==
        Provider.of<CreateExperimentController>(context)
            .experimentRequestModel
            .experimentsEnzymes
            .indexOf(enzyme)) {
      return EZTStepState.editing;
    } else if (_isEnzymeStillEmpty(enzyme.id)) {
      return EZTStepState.indexed;
    } else if (_isEnzymeCorrectlyFilled(enzyme.id)) {
      return EZTStepState.complete;
    } else {
      return EZTStepState.error;
    }
  }

  Widget _body(double height) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        const EZTCreateExperimentStepIndicator(
          title: "Cadastre um novo experimento",
          message: "Etapa 4 de 4 - Preencher variáveis",
        ),
        const SizedBox(
          height: 64,
        ),
        Expanded(
          child: SingleChildScrollView(
            child: EZTStepper(
              physics: const ClampingScrollPhysics(),
              currentStep: controller.stepPage,
              controlsBuilder:
                  (BuildContext context, EZTControlsDetails details) {
                return Row(
                  children: <Widget>[
                    if (controller.stepPage <
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
                      ),
                  ],
                );
              },
              onStepTapped: (int index) {
                controller.setStepPage(index);
              },
              type: EZTStepperType.vertical,
              steps: Provider.of<CreateExperimentController>(context)
                  .experimentRequestModel
                  .experimentsEnzymes
                  .map(
                (enzyme) {
                  return EZTStep(
                    state: _leadWithStepState(enzyme),
                    title: _isEnzymeCorrectlyFilled(enzyme.id)
                        ? Text(enzyme.name)
                        : Text(
                            "⚠  ${enzyme.name}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.danger,
                            ),
                          ),
                    content: Container(
                      alignment: Alignment.centerLeft,
                      child: Visibility(
                          visible:
                              controller.textFields["aVariable-${enzyme.id}"] !=
                                  null,
                          child: _textFields(enzyme)),
                    ),
                  );
                },
              ).toList(),
              key: ValueKey(widget.listOfEnzymes.hashCode),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFields(EnzymeModel enzyme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações da Curva:',
          style: TextStyles.detailBold,
        ),
        Row(
          children: [
            Expanded(
                child: controller.textFields["aVariable-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: controller.textFields["bVariable-${enzyme.id}"] ??
                    Container()),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          'Demais Variáveis:',
          style: TextStyles.detailBold,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: controller.textFields["duration-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child:
                    controller.textFields["size-${enzyme.id}"] ?? Container()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: controller.textFields["weightSample-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: controller.textFields["weightGround-${enzyme.id}"] ??
                    Container()),
          ],
        ),
      ],
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        if (enableNextButton)
          EZTButton(
            enabled: enableNextButton,
            text: 'Criar Experimento',
            onPressed: () async {
              widget.formKey.currentState!.save();

              if (widget.formKey.currentState!.validate()) {
                if (mounted) {
                  await controller.createExperiment(
                    controller.experimentRequestModel.name,
                    controller.experimentRequestModel.description,
                    controller.experimentRequestModel.repetitions,
                    controller.experimentRequestModel.processes,
                    controller.experimentRequestModel.experimentsEnzymes,
                    controller.textFields,
                  );
                }

                return;
              }
            },
          ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            controller.pageController.animateTo(
              MediaQuery.of(context).size.width * 2,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
            controller.setStepPage(0);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CreateExperimentController>();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: _body(MediaQuery.of(context).size.height),
          ),
          SizedBox(
            height: enableNextButton ? 160 : 100,
            child: Padding(
              padding: Constants.padding16all,
              child: _buttons,
            ),
          ),
        ],
      ),
    );
  }
}
