// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../../../../treatment/domain/entities/treatment_entity.dart';
import '../../../../dto/choosed_experiment_combination_dto.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
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
  bool? enableNextButton;
  EnzymeEntity? choosedEnzyme;
  // String? choosedEnzymeName;
  TreatmentEntity? choosedTreatment;
  // String? choosedTreatmentName;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();

    choosedEnzyme = _calculateExperimentViewmodel
        .temporaryChoosedExperimentCombination.enzyme;
    // choosedEnzymeName = _calculateExperimentViewmodel
    //     .temporaryChoosedExperimentCombination.enzyme?.name;
    choosedTreatment = _calculateExperimentViewmodel
        .temporaryChoosedExperimentCombination.treatment;
    // choosedTreatmentName = _calculateExperimentViewmodel
    //     .temporaryChoosedExperimentCombination.treatmentName;
    WidgetsBinding.instance.addPostFrameCallback((_) => _validateFields());
  }

  _validateFields() {
    if (choosedEnzyme != null && choosedTreatment != null) {
      _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(true);
    } else {
      _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(false);
    }
  }

  get _treatmentChoiceChip {
    return FormBuilderChoiceChip<TreatmentEntity>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: const InputDecoration(
        labelText: 'Selecione o tratamento:',
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
      ),
      initialValue: _calculateExperimentViewmodel
          .temporaryChoosedExperimentCombination.treatment,
      name: 'treatment',
      onChanged: (value) async {
        choosedEnzyme = null;
        // choosedEnzymeName = null;

        choosedTreatment = value;
        await _calculateExperimentViewmodel
            .getEnzymesRemainingInExperiment(value!.id);
        _validateFields();
      },
      options: _calculateExperimentViewmodel.experiment.treatments!
          .map(
            (e) => FormBuilderChipOption<TreatmentEntity>(
              value: e,
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

  get _enzymeChoiceChip {
    if (choosedTreatment != null) {
      if (_calculateExperimentViewmodel.enzymesRemaining.isEmpty) {
        if (_calculateExperimentViewmodel.state == StateEnum.loading) {
          return const Text('Carregando enzimas disponíveis...');
        }

        return const Text(
            'Todas as enzimas para este tratamento já foram calculadas!');
      }

      return FormBuilderChoiceChip<EnzymeEntity>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
          labelText: 'Selecione a enzima:',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
        initialValue: _calculateExperimentViewmodel
                .temporaryChoosedExperimentCombination.enzyme ??
            choosedEnzyme,

        name: 'enzyme',
        onChanged: (value) {
          if (value != null) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              "Tipo da enzima selecionada: ${Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(value.type)]}",
              color: Constants.dealWithEnzymeChipColor(
                value.type,
              ),
              textStyle: TextStyles.titleMinBoldBackground,
              centerTitle: true,
            );
          }

          choosedEnzyme = value;
          // choosedEnzymeName = _calculateExperimentViewmodel.experiment.enzymes!
          //     .firstWhere((x) => x.id == value)
          //     .name;
          _validateFields();
        },
        // options: _calculateExperimentViewmodel.experiment.enzymes!
        options: _calculateExperimentViewmodel.enzymesRemaining
            .map(
              (e) => FormBuilderChipOption<EnzymeEntity>(
                value: e,
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

    return Container();
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
              // var temporary = _calculateExperimentViewmodel
              //     .temporaryChoosedExperimentCombination;

              _calculateExperimentViewmodel
                  .setTemporaryChoosedExperimentCombination(
                ChoosedExperimentCombinationDTO(
                  enzyme: choosedEnzyme,
                  treatment: choosedTreatment,
                ),
              );

              await _calculateExperimentViewmodel
                  .generateTextFields(context)
                  .whenComplete(
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
    return AnimatedBuilder(
      animation: _calculateExperimentViewmodel,
      builder: (context, child) {
        return CalculateExperimentFragmentTemplate(
          titleOfStepIndicator: "Inserir dados no experimento",
          messageOfStepIndicator: "Etapa 1 de 3 - Identificação",
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
                      _calculateExperimentViewmodel
                          .experiment.enzymes!.isNotEmpty,
                  replacement: const EZTNotFound(
                    title: "Experimento inválido!",
                    message:
                        "Não é possível prosseguir sem dados de tratamento(s) e/ou enzima(s)",
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            PhosphorIcons.flask(),
                            // color: AppColors.greySweet, //TODO: COLOR-FIX
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
                                key: _calculateExperimentViewmodel
                                    .firstStepFormKey,
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
      },
    );
  }
}
