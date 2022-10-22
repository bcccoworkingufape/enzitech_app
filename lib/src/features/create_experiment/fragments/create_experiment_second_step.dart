// 🐦 Flutter imports:
// ignore_for_file: avoid_function_literals_in_foreach_calls

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/shared/models_/treatment_model.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_checkbox_tile.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_textfield.dart';
import 'package:enzitech_app/src/shared/utilities/util/constants.dart';
import 'package:enzitech_app/src/shared/utilities/validator/field_validator.dart';

class CreateExperimentSecondStepPage extends StatefulWidget {
  const CreateExperimentSecondStepPage({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  State<CreateExperimentSecondStepPage> createState() =>
      _CreateExperimentSecondStepPageState();
}

class _CreateExperimentSecondStepPageState
    extends State<CreateExperimentSecondStepPage> {
  late final CreateExperimentController controller;
  late final TreatmentsController treatmentsController;

  late GroupButtonController _checkboxesController;
  late final _checkboxButtons = [];
  List<TreatmentModel> choosedCheckboxList = <TreatmentModel>[];

  final _treatmentFieldController = TextEditingController(text: '');
  final _repetitionsFieldController = TextEditingController(text: '');

  bool enableNextButton2 = false;

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();
    treatmentsController = context.read<TreatmentsController>();
    Future.delayed(Duration.zero, () async {
      treatmentsController.loadTreatments().whenComplete(
            () => treatmentsController.treatments.forEach(
              (treat) {
                _checkboxButtons.add(treat.name);
              },
            ),
          );
    });

    _checkboxesController = GroupButtonController();

    initFieldControllerTexts();
  }

  void initFieldControllerTexts() {
    _repetitionsFieldController.text.isEmpty
        ? _treatmentFieldController.text =
            controller.experimentRequestModel.repetitions.toString()
        : null;

    enableNextButton2 = false;

    setState(() {});
  }

  get _validateFields {
    if (_repetitionsFieldController.text.isNotEmpty &&
        choosedCheckboxList.isNotEmpty) {
      setState(() {
        enableNextButton2 = widget.formKey.currentState!.validate();
      });
    } else {
      setState(() {
        enableNextButton2 = false;
      });
    }
  }

  Widget get _textFields {
    return Column(
      children: [
        const SizedBox(height: 10),
        _repetitionsInput,
      ],
    );
  }

  Widget get _repetitionsInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.number,
      ),
      ValidateRule(
        ValidateTypes.greaterThanZero,
      )
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Quantidade de repetições por tratamento",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.number,
      controller: _repetitionsFieldController,
      onChanged: (value) => _validateFields,
      fieldValidator: fieldValidator,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      // disableSuffixIcon: true,
    );
  }

  Widget get _body {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          const EZTCreateExperimentStepIndicator(
            title: "Cadastre um novo experimento",
            message: "Etapa 2 de 4 - Tratamentos e Repetições",
          ),
          const SizedBox(
            height: 64,
          ),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greySweet,
              ),
              const SizedBox(width: 4),
              Text(
                'Dados dos tratamentos e repetições',
                style: TextStyles.detailBold,
              ),
            ],
          ),
          Visibility(
            visible: treatmentsController.state == TreatmentsState.loading,
            replacement: GroupButton(
              controller: _checkboxesController,
              isRadio: false,
              options: const GroupButtonOptions(
                groupingType: GroupingType.column,
              ),
              buttons: _checkboxButtons,
              buttonIndexedBuilder: (selected, index, context) {
                return EZTCheckBoxTile(
                  title: _checkboxButtons[index],
                  selected: selected,
                  onTap: () {
                    if (!selected) {
                      _checkboxesController.selectIndex(index);
                      choosedCheckboxList
                          .add(treatmentsController.treatments[index]);

                      _validateFields;

                      return;
                    }
                    _checkboxesController.unselectIndex(index);
                    choosedCheckboxList
                        .remove(treatmentsController.treatments[index]);

                    _validateFields;
                  },
                );
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(64),
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Carregando tratamentos..."),
                ],
              ),
            ),
          ),
          _textFields,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableNextButton2,
          text: 'Próximo',
          onPressed: () {
            widget.formKey.currentState!.save();

            controller.experimentRequestModel.processes =
                choosedCheckboxList.map((processes) => processes.id).toList();
            controller.experimentRequestModel.repetitions =
                int.parse(_repetitionsFieldController.text);

            controller.pageController.nextPage(
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
    context.watch<TreatmentsController>();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Center(child: _body),
          ),
          SizedBox(
            height: 160,
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
