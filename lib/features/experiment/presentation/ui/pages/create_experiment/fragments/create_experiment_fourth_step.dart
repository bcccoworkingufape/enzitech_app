// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/state_enum.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../../viewmodel/create_experiment_viewmodel.dart';
import '../../../../viewmodel/experiment_details_viewmodel.dart';
import '../create_experiment_fragment_template.dart';

class CreateExperimentFourthStepPage extends StatefulWidget {
  const CreateExperimentFourthStepPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateExperimentFourthStepPage> createState() =>
      _CreateExperimentFourthStepPageState();
}

class _CreateExperimentFourthStepPageState
    extends State<CreateExperimentFourthStepPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;

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

  @override
  void initState() {
    super.initState();
    _createExperimentViewmodel = GetIt.I.get<CreateExperimentViewmodel>();

    Future.delayed(const Duration(milliseconds: 0)).whenComplete(() {
      if (mounted) {
        _createExperimentViewmodel.setStepPage(0, notify: false);

        final fieldValidator = FieldValidator(validations, context);
        final durationFieldValidator = FieldValidator([
          ...validations,
          ValidateRule(
            ValidateTypes.isInteger,
          )
        ], context);

        setState(() {
          textEditingControllers.clear();
          _createExperimentViewmodel.textFields.clear();

          for (var enzyme
              in _createExperimentViewmodel.temporaryExperiment.enzymes!) {
            TextEditingController aFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'aVariable-${enzyme.id}',
              () => aFieldController,
            );
            _createExperimentViewmodel.textFields
                .putIfAbsent('aVariable-${enzyme.id}', () {
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
            _createExperimentViewmodel.textFields.putIfAbsent(
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
            _createExperimentViewmodel.textFields.putIfAbsent(
              'duration-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Tempo (h)",
                usePrimaryColorOnFocusedBorder: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                controller: durationFieldController,
                onChanged: (value) => _validateFields,
                fieldValidator: durationFieldValidator,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // disableSuffixIcon: true,
              ),
            );

            TextEditingController sizeFieldController =
                TextEditingController(text: '');
            textEditingControllers.putIfAbsent(
              'size-${enzyme.id}',
              () => sizeFieldController,
            );
            _createExperimentViewmodel.textFields.putIfAbsent(
              'size-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Volume da Solução",
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
            _createExperimentViewmodel.textFields.putIfAbsent(
              'weightSample-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Peso da amostra (g)",
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
            _createExperimentViewmodel.textFields.putIfAbsent(
              'weightGround-${enzyme.id}',
              () => EZTTextField(
                eztTextFieldType: EZTTextFieldType.underline,
                labelText: "Fator de correção",
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
          }
        });
      }
    });
  }

  get _validateFields {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    if (mounted && isAllFilled.every((boolean) => boolean == true)) {
      setState(() {
        _createExperimentViewmodel.setEnableNextButtonOnFourthStep(true);
      });
    } else {
      setState(() {
        _createExperimentViewmodel.setEnableNextButtonOnFourthStep(false);
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
    Map<String, EZTTextField> filteredMap =
        Map.from(_createExperimentViewmodel.textFields)
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
    Map<String, EZTTextField> filteredMap =
        Map.from(_createExperimentViewmodel.textFields)
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
    if (_createExperimentViewmodel.stepPage ==
        _createExperimentViewmodel.temporaryExperiment.enzymes!
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
                child: _createExperimentViewmodel
                        .textFields["aVariable-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: _createExperimentViewmodel
                        .textFields["bVariable-${enzyme.id}"] ??
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
                child: _createExperimentViewmodel
                        .textFields["duration-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: _createExperimentViewmodel
                        .textFields["size-${enzyme.id}"] ??
                    Container()),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
                child: _createExperimentViewmodel
                        .textFields["weightSample-${enzyme.id}"] ??
                    Container()),
            const SizedBox(width: 10),
            Expanded(
                child: _createExperimentViewmodel
                        .textFields["weightGround-${enzyme.id}"] ??
                    Container()),
          ],
        ),
      ],
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        if (_createExperimentViewmodel.enableNextButtonOnFourthStep)
          EZTButton(
            enabled: _createExperimentViewmodel.enableNextButtonOnFourthStep,
            text: 'Criar Experimento',
            loading: _createExperimentViewmodel.state == StateEnum.loading,
            onPressed: () async {
              _createExperimentViewmodel.formKey.currentState!.save();

              if (_createExperimentViewmodel.formKey.currentState!.validate()) {
                if (mounted) {
                  await _createExperimentViewmodel.createExperiment();

                  GetIt.I
                      .get<ExperimentDetailsViewmodel>()
                      .getExperimentDetails(
                          _createExperimentViewmodel.experiment!.id);
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
            _createExperimentViewmodel.onBack(mounted, context);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _createExperimentViewmodel,
        builder: (context, child) {
          return CreateExperimentFragmentTemplate(
            titleOfStepIndicator: "Cadastre um novo experimento",
            messageOfStepIndicator: "Etapa 4 de 4 - Preencher variáveis",
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                children: [
                  EZTStepper(
                    physics: const ClampingScrollPhysics(),
                    currentStep: _createExperimentViewmodel.stepPage,
                    controlsBuilder:
                        (BuildContext context, EZTControlsDetails details) {
                      return Row(
                        children: <Widget>[
                          if (_createExperimentViewmodel.stepPage <
                              _createExperimentViewmodel
                                      .temporaryExperiment.enzymes!.length -
                                  1)
                            TextButton(
                              onPressed: () {
                                if (_createExperimentViewmodel.stepPage <
                                    _createExperimentViewmodel
                                            .temporaryExperiment
                                            .enzymes!
                                            .length -
                                        1) {
                                  _createExperimentViewmodel.setStepPage(
                                      _createExperimentViewmodel.stepPage + 1);
                                }
                              },
                              child: const Text('Próximo'),
                            ),
                          if (_createExperimentViewmodel.stepPage > 0)
                            TextButton(
                              onPressed: () {
                                if (_createExperimentViewmodel.stepPage > 0) {
                                  _createExperimentViewmodel.setStepPage(
                                      _createExperimentViewmodel.stepPage - 1);
                                }
                              },
                              child: const Text('Voltar'),
                            ),
                        ],
                      );
                    },
                    onStepTapped: (int index) {
                      _createExperimentViewmodel.setStepPage(index);
                    },
                    type: EZTStepperType.vertical,
                    steps: _createExperimentViewmodel
                        .temporaryExperiment.enzymes!
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
                                    // color: AppColors.danger, //TODO: COLOR-FIX
                                  ),
                                ),
                          content: Container(
                            alignment: Alignment.centerLeft,
                            child: Visibility(
                                visible: _createExperimentViewmodel
                                        .textFields["aVariable-${enzyme.id}"] !=
                                    null,
                                child: _textFields(enzyme)),
                          ),
                        );
                      },
                    ).toList(),

                    // key: ValueKey(widget.listOfEnzymes.hashCode),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 64, 16, 32),
                    child: _buttons,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
