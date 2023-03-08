import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../../../treatment/domain/entities/treatment_entity.dart';
import '../../../../../../treatment/presentation/viewmodel/treatments_viewmodel.dart';
import '../../../../dto/create_experiment_dto.dart';
import '../../../../viewmodel/create_experiment_viewmodel.dart';
import '../create_experiment_fragment_template.dart';

class CreateExperimentSecondStepPage extends StatefulWidget {
  const CreateExperimentSecondStepPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateExperimentSecondStepPage> createState() =>
      _CreateExperimentSecondStepPageState();
}

class _CreateExperimentSecondStepPageState
    extends State<CreateExperimentSecondStepPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;
  late final TreatmentsViewmodel _treatmentsViewmodel;

  final _repetitionsFieldController = TextEditingController(text: '');
  late GroupButtonController _checkboxesController;

  late final _checkboxButtons = [];
  List<TreatmentEntity> choosedCheckboxList = <TreatmentEntity>[];

  @override
  void initState() {
    super.initState();
    _createExperimentViewmodel = GetIt.I.get<CreateExperimentViewmodel>();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();

    for (var treat in _treatmentsViewmodel.treatments) {
      _checkboxButtons.add(treat.name);
    }

    _checkboxesController = GroupButtonController();

    Future.delayed(const Duration(milliseconds: 1))
        .whenComplete(() => _validateFields);

    _initFields();
  }

  void _initFields() {
    _repetitionsFieldController.text = _createExperimentViewmodel
            .temporaryExperiment.repetitions
            ?.toString() ??
        '';

    var tempTreat =
        _createExperimentViewmodel.temporaryExperiment.treatmentsIDs ?? [];

    if (tempTreat.isNotEmpty) {
      for (var id in tempTreat) {
        _checkboxesController.selectIndex(_treatmentsViewmodel.treatments
            .indexOf(
                _treatmentsViewmodel.treatments.firstWhere((t) => t.id == id)));

        choosedCheckboxList
            .add(_treatmentsViewmodel.treatments.firstWhere((t) => t.id == id));
      }
    }

    setState(() {});
  }

  get _validateFields {
    if (_repetitionsFieldController.text.isNotEmpty &&
        choosedCheckboxList.isNotEmpty) {
      setState(() {
        _createExperimentViewmodel.setEnableNextButtonOnSecondStep(
            _createExperimentViewmodel.formKey.currentState!.validate());
      });
    } else {
      setState(() {
        _createExperimentViewmodel.setEnableNextButtonOnSecondStep(false);
      });
    }
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
      disableSuffixIcon: true,
    );
  }

  Widget get _textFields {
    return Column(
      children: [
        const SizedBox(height: 10),
        _repetitionsInput,
      ],
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _createExperimentViewmodel.enableNextButtonOnSecondStep,
          text: 'Próximo',
          onPressed: () {
            _createExperimentViewmodel.formKey.currentState!.save();

            if (_createExperimentViewmodel.formKey.currentState!.validate()) {
              var temporary = _createExperimentViewmodel.temporaryExperiment;

              _createExperimentViewmodel.setCreateExperimentDTO(
                CreateExperimentDTO(
                  name: temporary.name,
                  description: temporary.description,
                  repetitions: int.parse(_repetitionsFieldController.text),
                  treatmentsIDs: choosedCheckboxList
                      .map((processes) => processes.id)
                      .toList(),
                ),
              );

              _createExperimentViewmodel.onNext(context);
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
  Widget build(BuildContext context) {
    return CreateExperimentFragmentTemplate(
      titleOfStepIndicator: "Cadastre um novo experimento",
      messageOfStepIndicator: "Etapa 2 de 4 - Tratamentos e Repetições",
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
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
            GroupButton(
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
                          .add(_treatmentsViewmodel.treatments[index]);

                      _validateFields;

                      return;
                    }
                    _checkboxesController.unselectIndex(index);
                    choosedCheckboxList
                        .remove(_treatmentsViewmodel.treatments[index]);

                    _validateFields;
                  },
                );
              },
            ),
            _textFields,
            const SizedBox(height: 64),
            _buttons,
          ],
        ),
      ),
    );
  }
}
