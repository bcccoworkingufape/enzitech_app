// ignore_for_file: avoid_function_literals_in_foreach_calls

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/ui/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/features/create_experiment/viewmodel/create_experiment_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

// TODO: Verify dispose error
class CreateExperimentFourthStepPage extends StatefulWidget {
  const CreateExperimentFourthStepPage({
    Key? key,
    required this.callback,
    required this.formKey,
    required this.listOfEnzymes,
  }) : super(key: key);

  final void Function({int page}) callback;
  final GlobalKey<FormState> formKey;
  final List<EnzymeEntity> listOfEnzymes;

  @override
  State<CreateExperimentFourthStepPage> createState() =>
      _CreateExperimentFourthStepPageState();
}

class _CreateExperimentFourthStepPageState
    extends State<CreateExperimentFourthStepPage> {
  late final CreateExperimentViewmodel viewmodel;

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
    viewmodel = context.read<CreateExperimentViewmodel>();

    Future.delayed(const Duration(milliseconds: 0)).whenComplete(() {
      if (mounted) {
        viewmodel.setStepPage(0, notify: false);

        final fieldValidator = FieldValidator(validations, context);

        setState(() {
          textEditingControllers.clear();
          viewmodel.textFields.clear();

          viewmodel.experimentRequestModel.experimentsEnzymes.forEach((enzyme) {
            TextEditingController aFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'aVariable-${enzyme.id}',
              () => aFieldController,
            );
            viewmodel.textFields.putIfAbsent('aVariable-${enzyme.id}', () {
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
            viewmodel.textFields.putIfAbsent(
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
            viewmodel.textFields.putIfAbsent(
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
            viewmodel.textFields.putIfAbsent(
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
            viewmodel.textFields.putIfAbsent(
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
            viewmodel.textFields.putIfAbsent(
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
    Map<String, EZTTextField> filteredMap = Map.from(viewmodel.textFields)
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
    Map<String, EZTTextField> filteredMap = Map.from(viewmodel.textFields)
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

  EZTStepState _leadWithStepState(EnzymeEntity enzyme) {
    if (viewmodel.stepPage ==
        Provider.of<CreateExperimentViewmodel>(context)
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
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: EZTStepper(
              physics: const ClampingScrollPhysics(),
              currentStep: viewmodel.stepPage,
              controlsBuilder:
                  (BuildContext context, EZTControlsDetails details) {
                return Row(
                  children: <Widget>[
                    if (viewmodel.stepPage <
                        Provider.of<CreateExperimentViewmodel>(context,
                                    listen: false)
                                .experimentRequestModel
                                .experimentsEnzymes
                                .length -
                            1)
                      TextButton(
                        onPressed: () {
                          if (viewmodel.stepPage <
                              Provider.of<CreateExperimentViewmodel>(context,
                                          listen: false)
                                      .experimentRequestModel
                                      .experimentsEnzymes
                                      .length -
                                  1) {
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
              steps: Provider.of<CreateExperimentViewmodel>(context)
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
                              viewmodel.textFields["aVariable-${enzyme.id}"] !=
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

  Widget _textFields(EnzymeEntity enzyme) {
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
                child: viewmodel.textFields["aVariable-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: viewmodel.textFields["bVariable-${enzyme.id}"] ??
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
                child: viewmodel.textFields["duration-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child:
                    viewmodel.textFields["size-${enzyme.id}"] ?? Container()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: viewmodel.textFields["weightSample-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: viewmodel.textFields["weightGround-${enzyme.id}"] ??
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
                  await viewmodel.createExperiment(
                    viewmodel.experimentRequestModel.name,
                    viewmodel.experimentRequestModel.description,
                    viewmodel.experimentRequestModel.repetitions,
                    viewmodel.experimentRequestModel.processes,
                    viewmodel.experimentRequestModel.experimentsEnzymes,
                    viewmodel.textFields,
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
            widget.callback(page: 2);
            viewmodel.setStepPage(0);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CreateExperimentViewmodel>();

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
