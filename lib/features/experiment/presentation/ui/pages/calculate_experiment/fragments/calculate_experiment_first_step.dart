import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../dto/choosed_experiment_combination_dto.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../../../../viewmodel/experiments_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class CalculateExperimentFirstStepPage extends StatefulWidget {
  const CalculateExperimentFirstStepPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CalculateExperimentFirstStepPage> createState() =>
      _CalculateExperimentFirstStepPageState();
}

class _CalculateExperimentFirstStepPageState
    extends State<CalculateExperimentFirstStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;
  bool? enableNextButton;
  String? choosedEnzyme;
  String? choosedTreatment;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();

    choosedEnzyme = _calculateExperimentViewmodel
        .temporaryChoosedExperimentCombination.enzymeId;
    choosedTreatment = _calculateExperimentViewmodel
        .temporaryChoosedExperimentCombination.treatmentId;
    _validateFields();

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

  _validateFields() {
    setState(() {
      if (choosedEnzyme != null && choosedTreatment != null) {
        _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(true);
      } else {
        _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(false);
      }
    });
  }

  get _treatmentChoiceChip {
    return FormBuilderChoiceChip<dynamic>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Selecione o tratamento:',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
      initialValue: _calculateExperimentViewmodel
          .temporaryChoosedExperimentCombination.treatmentId,
      name: 'treatment',
      onChanged: (value) {
        choosedTreatment = value;
        _validateFields();
      },
      options: _calculateExperimentViewmodel.experiment.treatments!
          .map(
            (e) => FormBuilderChipOption(
              value: e.id,
              child: Text(e.name),
              // avatar: CircleAvatar(child: Text(e.name[0])),
            ),
          )
          .toList(),
      selectedColor: AppColors.primary,
      spacing: 4,
      validator: FormBuilderValidators.compose(
        [FormBuilderValidators.required()],
      ),
    );
  }

  get _enzymeChoiceChip {
    return FormBuilderChoiceChip<dynamic>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Selecione a enzima:',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
      initialValue: _calculateExperimentViewmodel
          .temporaryChoosedExperimentCombination.enzymeId,
      name: 'enzyme',
      onChanged: (value) {
        if (value != null) {
          EZTSnackBar.clear(context);
          EZTSnackBar.show(
            context,
            "Tipo da enzima selecionada: ${Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(_calculateExperimentViewmodel.experiment.enzymes!.firstWhere((x) => x.id == value).type)]}",
            color: Constants.dealWithEnzymeChipColor(
              _calculateExperimentViewmodel.experiment.enzymes!
                  .firstWhere((x) => x.id == value)
                  .type,
            ),
            textStyle: TextStyles.titleMinBoldBackground,
            centerTitle: true,
          );
        }

        choosedEnzyme = value;
        _validateFields();
      },
      options: _calculateExperimentViewmodel.experiment.enzymes!
          .map(
            (e) => FormBuilderChipOption(
              value: e.id,
              avatar: CircleAvatar(
                backgroundColor: Constants.dealWithEnzymeChipColor(e.type),
              ),
              child: Text(e.name),
            ),
          )
          .toList(),
      selectedColor: AppColors.primary,
      spacing: 4,
      validator: FormBuilderValidators.compose(
        [FormBuilderValidators.required()],
      ),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnFirstStep,
          text: 'Próximo',
          loading: _calculateExperimentViewmodel.state == StateEnum.loading
              ? true
              : false,
          onPressed: () async {
            _calculateExperimentViewmodel.formKey.currentState?.save();

            if (_calculateExperimentViewmodel.formKey.currentState!
                .validate()) {
              var temporary = _calculateExperimentViewmodel
                  .temporaryChoosedExperimentCombination;

              _calculateExperimentViewmodel
                  .setTemporaryChoosedExperimentCombination(
                ChoosedExperimentCombinationDTO(
                  enzymeId: choosedEnzyme,
                  treatmentId: choosedTreatment,
                ),
              );
              _calculateExperimentViewmodel.onNext(context);
            }

            /* EZTSnackBar.clear(context);
            if (formKey.currentState?.saveAndValidate() ?? false) {
              _calculateExperimentViewmodel.setChoosedEnzymeAndTreatment(
                formKey.currentState!.value,
              );

              await _calculateExperimentViewmodel
                  .generateTextFields(context)
                  .whenComplete(() {
                _calculateExperimentViewmodel.pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeIn,
                );
              });
            } */
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            _calculateExperimentViewmodel.onBack(mounted, context);
            // widget.callback();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CalculateExperimentFragmentTemplate(
      titleOfStepIndicator: "Inserir dados no experimento",
      messageOfStepIndicator: "Etapa 1 de 2 - Identificação",
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
            Visibility(
              visible: _calculateExperimentViewmodel
                      .experiment.treatments!.isNotEmpty &&
                  _calculateExperimentViewmodel.experiment.enzymes!.isNotEmpty,
              replacement: const EZTNotFound(
                title: "Experimento inválido!",
                message:
                    "Não é possível prosseguir sem dados de tratamento(s) e/ou enzima(s)",
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        PhosphorIcons.flask,
                        color: AppColors.greySweet,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Escolha o tratamento e a enzima para inserir os dados',
                          style: TextStyles.detailBold,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          FormBuilder(
                            key: _calculateExperimentViewmodel.firstStepFormKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            skipDisabled: true,
                            child: Column(
                              children: <Widget>[
                                _treatmentChoiceChip,
                                const SizedBox(height: 16),
                                _enzymeChoiceChip,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
  }
}
