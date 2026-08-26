// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/validator/security_validators.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../dto/create_experiment_dto.dart';
import '../../../../dto/pending_treatment_dto.dart';
import '../../../../viewmodel/create_experiment_viewmodel.dart';
import '../create_experiment_fragment_template.dart';

class CreateExperimentSecondStepPage extends StatefulWidget {
  const CreateExperimentSecondStepPage({super.key});

  @override
  State<CreateExperimentSecondStepPage> createState() => _CreateExperimentSecondStepPageState();
}

class _CreateExperimentSecondStepPageState extends State<CreateExperimentSecondStepPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;

  final _repetitionsFieldController = TextEditingController(text: '');
  final _treatmentNameFieldController = TextEditingController(text: '');
  final _treatmentDescriptionFieldController = TextEditingController(text: '');

  final List<PendingTreatmentDTO> _addedTreatments = [];

  @override
  void initState() {
    super.initState();
    _createExperimentViewmodel = GetIt.I.get<CreateExperimentViewmodel>();

    _initFields();
  }

  void _initFields() {
    _repetitionsFieldController.text = _createExperimentViewmodel.temporaryExperiment.repetitions?.toString() ?? '';
    _addedTreatments.addAll(_createExperimentViewmodel.temporaryExperiment.treatments ?? []);

    setState(() {});
  }

  void _validateFields() {
    setState(() {
      _createExperimentViewmodel.setEnableNextButtonOnSecondStep(
        _repetitionsFieldController.text.isNotEmpty && _addedTreatments.isNotEmpty,
      );
    });
  }

  void _addTreatment() {
    if (_treatmentNameFieldController.text.trim().isEmpty) {
      return;
    }

    setState(() {
      _addedTreatments.add(
        PendingTreatmentDTO(
          name: _treatmentNameFieldController.text.trim(),
          description: _treatmentDescriptionFieldController.text.trim(),
        ),
      );
      _treatmentNameFieldController.clear();
      _treatmentDescriptionFieldController.clear();
    });

    _validateFields();
  }

  void _removeTreatmentAt(int index) {
    setState(() {
      _addedTreatments.removeAt(index);
    });

    _validateFields();
  }

  Widget get _addTreatmentForm {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.nameLabel,
          usePrimaryColorOnFocusedBorder: true,
          controller: _treatmentNameFieldController,
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.descriptionLabel,
          usePrimaryColorOnFocusedBorder: true,
          controller: _treatmentDescriptionFieldController,
        ),
        const SizedBox(height: 10),
        EZTButton(
          eztButtonType: EZTButtonType.outline,
          text: context.l10n.addTreatmentButton,
          icon: Icon(PhosphorIcons.plus, color: context.getApplyedColorScheme.primary),
          onPressed: _addTreatment,
        ),
      ],
    );
  }

  Widget get _addedTreatmentsList {
    if (_addedTreatments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(context.l10n.noTreatmentsAddedYet, style: TextStyles(context).bodyRegular),
      );
    }

    return Column(
      children: List.generate(_addedTreatments.length, (index) {
        final treatment = _addedTreatments[index];
        return Card(
          margin: const EdgeInsets.only(top: 8),
          color: context.getApplyedColorScheme.surface,
          child: ListTile(
            title: Text(treatment.name, style: TextStyles.detailBold),
            subtitle: treatment.description.isEmpty
                ? null
                : Text(treatment.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: Icon(PhosphorIcons.trash, color: context.getApplyedColorScheme.error),
              onPressed: () => _removeTreatmentAt(index),
            ),
          ),
        );
      }),
    );
  }

  Widget get _repetitionsInput {
    final validations = SecurityValidators.repetitions();

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: context.l10n.repetitionsPerTreatmentLabel,
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.number,
      controller: _repetitionsFieldController,
      onChanged: (value) => _validateFields(),
      fieldValidator: fieldValidator,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      disableSuffixIcon: true,
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _createExperimentViewmodel.enableNextButtonOnSecondStep,
          text: context.l10n.nextButton,
          onPressed: () {
            _createExperimentViewmodel.formKey.currentState!.save();

            if (_createExperimentViewmodel.formKey.currentState!.validate()) {
              var temporary = _createExperimentViewmodel.temporaryExperiment;

              _createExperimentViewmodel.setTemporaryExperiment(
                CreateExperimentDTO(
                  name: temporary.name,
                  description: temporary.description,
                  repetitions: int.parse(_repetitionsFieldController.text),
                  treatments: _addedTreatments,
                  enzymes: temporary.enzymes,
                ),
              );

              _createExperimentViewmodel.onNext(context);
            }
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: context.l10n.backButton,
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
      titleOfStepIndicator: context.l10n.registerNewExperiment,
      messageOfStepIndicator: context.l10n.stepIndicatorTreatments(2, 4),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 17),
            Row(
              children: [
                Icon(PhosphorIcons.flask),
                const SizedBox(width: 4),
                Text(context.l10n.treatmentsAndRepetitionsData, style: TextStyles.detailBold),
              ],
            ),
            const SizedBox(height: 8),
            _addTreatmentForm,
            _addedTreatmentsList,
            const SizedBox(height: 24),
            _repetitionsInput,
            const SizedBox(height: 64),
            _buttons,
          ],
        ),
      ),
    );
  }
}
