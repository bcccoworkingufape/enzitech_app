// 🐦 Flutter imports:
import 'dart:convert';
import 'dart:developer';

import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/shared/models/treatment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import '../../../shared/models/experiment_request_model.dart';
import '../../../shared/themes/app_complete_theme.dart';
import '../../../shared/util/constants.dart';
import '../../../shared/validator/field_validator.dart';
import '../../../shared/widgets/ezt_button.dart';
import '../../../shared/widgets/ezt_textfield.dart';
import '../../../shared/widgets/ezt_checkbox_tile.dart';

class CreateExperimentSecondStepPage extends StatefulWidget {
  const CreateExperimentSecondStepPage({
    Key? key,
    required this.pageController,
    required this.formKey,
    required this.experimentRequestModel,
  }) : super(key: key);

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final ExperimentRequestModel experimentRequestModel;

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
  List<TreatmentModel> _choosedCheckboxList = <TreatmentModel>[];

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
    var b = widget.experimentRequestModel.processes.isNotEmpty;

    // _choosedCheckboxList.isEmpty
    //     ? _choosedCheckboxList =
    //         (jsonDecode(widget.experimentDataCache['processes']!)
    //             as List<TreatmentModel>)
    //     : null;
    _repetitionsFieldController.text.isEmpty
        ? _treatmentFieldController.text =
            widget.experimentRequestModel.repetitions.toString()
        : null;

    enableNextButton2 = false;

    setState(() {});
  }

  get _validateFields {
    if (_repetitionsFieldController.text.isNotEmpty &&
        _choosedCheckboxList.isNotEmpty) {
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
        // _treatmentInput,
        const SizedBox(height: 10),
        _repetitionsInput,
      ],
    );
  }

  // Widget get _treatmentInput {
  //   final validations = <ValidateRule>[
  //     ValidateRule(
  //       ValidateTypes.required,
  //     ),
  //     ValidateRule(
  //       ValidateTypes.name,
  //     ),
  //   ];

  //   final fieldValidator = FieldValidator(validations, context);

  //   return EZTTextField(
  //     eztTextFieldType: EZTTextFieldType.underline,
  //     labelText: "Tratamentos",
  //     usePrimaryColorOnFocusedBorder: true,
  //     keyboardType: TextInputType.name,
  //     controller: _treatmentFieldController,
  //     onChanged: (value) => _validateFields,
  //     fieldValidator: fieldValidator,
  //     // disableSuffixIcon: true,
  //   );
  // }

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
      labelText: "Qtd. de repetições por tratamento",
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
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greyMedium,
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
                    _validateFields;

                    if (!selected) {
                      _checkboxesController.selectIndex(index);
                      _choosedCheckboxList
                          .add(treatmentsController.treatments[index]);
                      log(_choosedCheckboxList.toString());
                      // setState(() {
                      //   enableNextButton2 = _choosedCheckboxList.isNotEmpty;
                      // });

                      return;
                    }
                    _checkboxesController.unselectIndex(index);
                    _choosedCheckboxList
                        .remove(treatmentsController.treatments[index]);
                    // setState(() {
                    //   enableNextButton2 = _choosedCheckboxList.isNotEmpty;
                    // });

                    log(_choosedCheckboxList.toString());
                  },
                );
              },
              onSelected: (val, i, selected) =>
                  debugPrint('Button: $val index: $i $selected'),
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
            // initFieldControllerTexts();
            widget.formKey.currentState!.save();

            widget.experimentRequestModel.processes =
                _choosedCheckboxList.map((processes) => processes.id).toList();
            widget.experimentRequestModel.repetitions =
                int.parse(_repetitionsFieldController.text);
            // widget.experimentDataCache
            //     .update('enableNextButton2', (value) => 'true');

            widget.pageController.nextPage(
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
            widget.pageController.animateTo(
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

    return Column(
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
    );
  }
}
