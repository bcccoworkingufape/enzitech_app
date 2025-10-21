// 🐦 Flutter imports:

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../../../../treatment/domain/entities/treatment_entity.dart';
import '../../../../dto/choosed_experiment_combination_dto.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class CalculateExperimentFirstStepPage extends StatefulWidget {
  const CalculateExperimentFirstStepPage({super.key});

  @override
  State<CalculateExperimentFirstStepPage> createState() => _CalculateExperimentFirstStepPageState();
}

class _CalculateExperimentFirstStepPageState extends State<CalculateExperimentFirstStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;
  bool? enableNextButton;
  EnzymeEntity? choosedEnzyme;
  TreatmentEntity? choosedTreatment;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();

    choosedEnzyme = _calculateExperimentViewmodel.temporaryChoosedExperimentCombination.enzyme;
    choosedTreatment = _calculateExperimentViewmodel.temporaryChoosedExperimentCombination.treatment;

    WidgetsBinding.instance.addPostFrameCallback((_) => _validateFields());
  }

  void _validateFields() {
    if (choosedEnzyme != null && choosedTreatment != null) {
      _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(true);
    } else {
      _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(false);
    }
  }

  FormBuilderChoiceChips<TreatmentEntity> get _treatmentChoiceChip {
    return FormBuilderChoiceChips<TreatmentEntity>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: context.l10n.selectTreatment,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
      initialValue: _calculateExperimentViewmodel.temporaryChoosedExperimentCombination.treatment,
      name: 'treatment',
      onChanged: (value) async {
        choosedEnzyme = null;

        choosedTreatment = value;
        await _calculateExperimentViewmodel.getEnzymesRemainingInExperiment(value!.id);
        _validateFields();
      },
      options: _calculateExperimentViewmodel.experiment.treatments!
          .map((e) => FormBuilderChipOption<TreatmentEntity>(value: e, child: Text(e.name)))
          .toList(),
      selectedColor: context.getApplyedColorScheme.primaryContainer,
      spacing: 4,
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
    );
  }

  Widget get _enzymeChoiceChip {
    if (choosedTreatment != null) {
      if (_calculateExperimentViewmodel.enzymesRemaining.isEmpty) {
        if (_calculateExperimentViewmodel.state == StateEnum.loading) {
          return Text(context.l10n.loadingAvailableEnzymes);
        }

        return Text(context.l10n.allEnzymesCalculated);
      }

      return FormBuilderChoiceChips<EnzymeEntity>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: context.l10n.selectEnzyme,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
        initialValue: _calculateExperimentViewmodel.temporaryChoosedExperimentCombination.enzyme ?? choosedEnzyme,
        name: 'enzyme',
        onChanged: (value) {
          if (value != null) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              context.l10n.selectedEnzymeType(
                Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(value.type)],
              ),
              color: Constants.dealWithEnzymeChipColor(value.type),
              textStyle: TextStyles(context).titleMinBoldBackground(),
              centerTitle: true,
            );
          }

          choosedEnzyme = value;

          _validateFields();
        },
        options: _calculateExperimentViewmodel.enzymesRemaining
            .map(
              (e) => FormBuilderChipOption<EnzymeEntity>(
                value: e,
                avatar: CircleAvatar(backgroundColor: Constants.dealWithEnzymeChipColor(e.type)),
                child: Text(e.name),
              ),
            )
            .toList(),
        selectedColor: context.getApplyedColorScheme.primaryContainer,
        spacing: 4,
        validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      );
    }

    return Container();
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnFirstStep,
          text: context.l10n.nextButton,
          loading: _calculateExperimentViewmodel.state == StateEnum.loading ? true : false,
          onPressed: () async {
            _calculateExperimentViewmodel.formKey.currentState?.save();

            if (_calculateExperimentViewmodel.formKey.currentState!.validate()) {
              _calculateExperimentViewmodel.setTemporaryChoosedExperimentCombination(
                ChoosedExperimentCombinationDTO(enzyme: choosedEnzyme, treatment: choosedTreatment),
              );

              await _calculateExperimentViewmodel.generateTextFields().whenComplete(
                () => Future.delayed(Duration.zero, () {
                  _calculateExperimentViewmodel.setStepPage(0);

                  _calculateExperimentViewmodel.onNext(context);
                }),
              );
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: context.l10n.backButton,
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            _calculateExperimentViewmodel.onBack(mounted, context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _calculateExperimentViewmodel,
      builder: (context, child) {
        return CalculateExperimentFragmentTemplate(
          titleOfStepIndicator: context.l10n.insertExperimentData,
          messageOfStepIndicator: context.l10n.stepIndicatorMessage(1, 3),

          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Visibility(
                  visible:
                      _calculateExperimentViewmodel.experiment.treatments!.isNotEmpty &&
                      _calculateExperimentViewmodel.experiment.enzymes!.isNotEmpty,
                  replacement: EZTNotFound(
                    title: context.l10n.invalidExperimentTitle,
                    message: context.l10n.invalidExperimentMessage,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(PhosphorIcons.flask()),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              context.l10n.chooseTreatmentAndEnzyme,
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
                const SizedBox(height: 64),
                _buttons,
              ],
            ),
          ),
        );
      },
    );
  }
}
