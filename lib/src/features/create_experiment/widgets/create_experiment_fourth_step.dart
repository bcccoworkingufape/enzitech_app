import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import '../../../shared/themes/app_complete_theme.dart';
import '../../../shared/util/constants.dart';
import '../../../shared/validator/field_validator.dart';
import '../../../shared/widgets/ezt_button.dart';
import '../../../shared/widgets/ezt_stepper.dart';
import '../../../shared/widgets/ezt_textfield.dart';

// TODO: REDO 4th STEP
class CreateExperimentFourthStepPage extends StatefulWidget {
  const CreateExperimentFourthStepPage({
    Key? key,
    // required this.pageController,
    required this.formKey,
    required this.listOfEnzymes,
  }) : super(key: key);

  // final PageController pageController;
  final GlobalKey<FormState> formKey;
  final List<EnzymeModel> listOfEnzymes;

  @override
  State<CreateExperimentFourthStepPage> createState() =>
      _CreateExperimentFourthStepPageState();
}

class _CreateExperimentFourthStepPageState
    extends State<CreateExperimentFourthStepPage> {
  late final CreateExperimentController controller;

  // int _index = 0;

  // This list of controllers can be used to set and get the text from/to the TextFields
  Map<String, TextEditingController> textEditingControllers = {};
  // Map<String, EZTTextField> textFields = {};

  final validations = <ValidateRule>[
    ValidateRule(
      ValidateTypes.required,
    ),
    ValidateRule(
      ValidateTypes.numeric,
    ),
  ];

  bool enableNextButton = false;

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();

    if (mounted) {
      controller.setStepPage(0, notify: false);

      final fieldValidator = FieldValidator(validations, context);

      setState(() {
        textEditingControllers.clear();
        controller.textFields.clear();

        controller.experimentRequestModel.experimentsEnzymes.forEach((enzyme) {
          var aFieldController = TextEditingController(text: '');
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
              keyboardType: TextInputType.number,
              controller: aFieldController,
              enabled: false,
              onChanged: (value) => _validateFields,
              fieldValidator: fieldValidator,
              // disableSuffixIcon: true,
            );
          });

          var bFieldController = TextEditingController(text: '');
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
                keyboardType: TextInputType.number,
                controller: bFieldController,
                enabled: false,
                onChanged: (value) => _validateFields,
                fieldValidator: fieldValidator,
                // disableSuffixIcon: true,
              );
            },
          );

          final durationFieldController = TextEditingController(text: '');
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
              keyboardType: TextInputType.number,
              controller: durationFieldController,
              onChanged: (value) => _validateFields,
              fieldValidator: fieldValidator,
              // disableSuffixIcon: true,
            ),
          );

          final sizeFieldController = TextEditingController(text: '');
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
              keyboardType: TextInputType.number,
              controller: sizeFieldController,
              onChanged: (value) => _validateFields,
              fieldValidator: fieldValidator,
              // disableSuffixIcon: true,
            ),
          );

          final weightSampleFieldController = TextEditingController(text: '');
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
              keyboardType: TextInputType.number,
              controller: weightSampleFieldController,
              onChanged: (value) => _validateFields,
              fieldValidator: fieldValidator,
              // disableSuffixIcon: true,
            ),
          );

          final weightGroundFieldController = TextEditingController(text: '');
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
              keyboardType: TextInputType.number,
              controller: weightGroundFieldController,
              onChanged: (value) => _validateFields,
              fieldValidator: fieldValidator,
              // disableSuffixIcon: true,
            ),
          );
          // return;
        });
      });
    }
  }

  @override
  void dispose() {
    textEditingControllers.forEach((_, tec) {
      tec.dispose();
    });
    super.dispose();
  }

  get _validateFields {
    var isAllFilled = <bool>[];
    textEditingControllers.forEach((key, value) {
      isAllFilled.add(value.text.isNotEmpty);
    });
    var a = isAllFilled.every((boolean) => boolean == true);
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

  Widget _body(double height) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppSvgs.iconLogo,
              alignment: Alignment.center,
              width: 75,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Cadastre um novo\nexperimento",
              style: TextStyles.titleHome,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: height),
            child: EZTStepper(
                currentStep: controller.stepPage,
                onStepCancel: () {
                  if (controller.stepPage > 0) {
                    controller.setStepPage(controller.stepPage - 1);
                  }
                },
                onStepContinue: () {
                  if (controller.stepPage <= 0) {
                    controller.setStepPage(controller.stepPage + 1);
                  }
                },
                onStepTapped: (int index) {
                  controller.setStepPage(index);
                },
                type: EZTStepperType.horizontal,
                steps: Provider.of<CreateExperimentController>(context)
                    .experimentRequestModel
                    .experimentsEnzymes
                    .map(
                      (enzyme) => EZTStep(
                        title: Text(enzyme.name),
                        content: Container(
                          alignment: Alignment.centerLeft,
                          child: Visibility(
                              visible: controller
                                      .textFields["aVariable-${enzyme.id}"] !=
                                  null,
                              child: _textFields(enzyme)),
                        ),
                      ),
                    )
                    .toList(),
                key: ValueKey(widget.listOfEnzymes.hashCode)
                // key: Key(Random.secure().nextDouble().toString()),
                ),
          ),
          const SizedBox(height: 40),
          // _textFields,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget _textFields(EnzymeModel enzyme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informações da Curva',
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
          'Demais Variáveis',
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

    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Center(child: _body(MediaQuery.of(context).size.height / 2.5)),
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
    );
  }
}
