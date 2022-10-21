// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/experiment_insert_data_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_not_found.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class ExperimentChooseEnzymeAndTreatmentPage extends StatefulWidget {
  const ExperimentChooseEnzymeAndTreatmentPage({
    Key? key,
    required this.formKey,
    required this.callback,
  }) : super(key: key);
  final void Function() callback;
  final GlobalKey<FormBuilderState> formKey;

  @override
  State<ExperimentChooseEnzymeAndTreatmentPage> createState() =>
      _ExperimentChooseEnzymeAndTreatmentPageState();
}

class _ExperimentChooseEnzymeAndTreatmentPageState
    extends State<ExperimentChooseEnzymeAndTreatmentPage> {
  late final ExperimentInsertDataController controller;
  late final ExperimentsController experimentsController;
  bool? enableNextButton;

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentInsertDataController>();
    experimentsController = context.read<ExperimentsController>();

    if (mounted) {
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
    }
  }

  Widget get _body {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          const EZTCreateExperimentStepIndicator(
            title: "Inserir dados no experimento",
            message: "Etapa 1 de 3 - Identificação",
          ),
          const SizedBox(
            height: 64,
          ),
          Visibility(
            visible: controller.experiment.treatments!.isNotEmpty &&
                controller.experiment.enzymes!.isNotEmpty,
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
                    Text(
                      'Escolha o tratamento e a enzima para inserir os dados',
                      style: TextStyles.detailBold,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        FormBuilder(
                          key: widget.formKey,
                          // enabled: false,
                          onChanged: () {
                            widget.formKey.currentState!.save();
                            setState(() {
                              if (widget.formKey.currentState?.value.values
                                      .every((element) => element != null) ??
                                  false) {
                                enableNextButton =
                                    widget.formKey.currentState?.validate();
                                controller.setChoosedEnzymeAndTreatment(
                                  widget.formKey.currentState!.value,
                                );
                              } else {
                                enableNextButton = false;
                              }
                            });

                            debugPrint(
                                widget.formKey.currentState!.value.toString());
                          },
                          initialValue: controller.choosedEnzymeAndTreatment,
                          autovalidateMode: AutovalidateMode.disabled,
                          // autoFocusOnValidationFailure: true,
                          skipDisabled: true,
                          child: Column(
                            children: <Widget>[
                              FormBuilderChoiceChip<dynamic>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()],
                                ),

                                selectedColor: AppColors.primary,
                                decoration: const InputDecoration(
                                  labelText: 'Selecione o tratamento:',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                name: 'process',

                                // initialValue: 'Dart',
                                spacing: 4,
                                options: controller.experiment.treatments!
                                    .map(
                                      (e) => FormBuilderChipOption(
                                        value: e.id,
                                        child: Text(e.name),
                                        // avatar: CircleAvatar(child: Text(e.name[0])),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 32),
                              FormBuilderChoiceChip<dynamic>(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required()],
                                ),
                                selectedColor: AppColors.primary,
                                decoration: const InputDecoration(
                                  labelText: 'Selecione a enzima:',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                name: 'enzyme',
                                // initialValue: 'Dart',
                                spacing: 4,
                                options: controller.experiment.enzymes!
                                    .map(
                                      (e) => FormBuilderChipOption(
                                        value: e.id,
                                        avatar: CircleAvatar(
                                          backgroundColor:
                                              Constants.dealWithEnzymeChipColor(
                                                  e.type),
                                        ),
                                        child: Text(e.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  EZTSnackBar.clear(context);
                                  EZTSnackBar.show(
                                    context,
                                    "Tipo da enzima selecionada: ${Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(controller.experiment.enzymes!.firstWhere((x) => x.id == value).type)]}",
                                    color: Constants.dealWithEnzymeChipColor(
                                      controller.experiment.enzymes!
                                          .firstWhere((x) => x.id == value)
                                          .type,
                                    ),
                                    textStyle:
                                        TextStyles.titleMinBoldBackground,
                                    centerTitle: true,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        /* Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (widget.formKey.currentState?.saveAndValidate() ??
                          false) {
                        debugPrint(
                            widget.formKey.currentState?.value.toString());
                        controller.pageController.animateTo(
                          MediaQuery.of(context).size.width,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeIn,
                        );
                      } else {
                        debugPrint(
                            widget.formKey.currentState?.value.toString());
                        debugPrint('validation failed');
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      widget.formKey.currentState?.reset();
                    },
                    // color: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ],
            ), */
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableNextButton ??
              (widget.formKey.currentState?.validate() ??
                  (controller.choosedEnzymeAndTreatment['process'] != null &&
                      controller.choosedEnzymeAndTreatment['enzyme'] != null)),
          text: 'Próximo',
          onPressed: () {
            EZTSnackBar.clear(context);
            if (widget.formKey.currentState?.saveAndValidate() ?? false) {
              controller.setChoosedEnzymeAndTreatment(
                widget.formKey.currentState!.value,
              );

              controller.generateTextFields(context);

              controller.pageController.animateTo(
                MediaQuery.of(context).size.width,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeIn,
              );
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            widget.callback();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentInsertDataController>();
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Center(child: _body),
        ),
        SizedBox(
          height: 128,
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
