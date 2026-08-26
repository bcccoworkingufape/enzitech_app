// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../../../enzyme/data/dto/enzyme_dto.dart';
import '../../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../../../enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../../../treatment/domain/entities/treatment_entity.dart';
import '../../../../../treatment/presentation/viewmodel/treatments_viewmodel.dart';
import '../../../../domain/entities/experiment_entity.dart';
import '../../../viewmodel/edit_experiment_viewmodel.dart';
import '../../../viewmodel/experiment_details_viewmodel.dart';

class EditExperimentPage extends StatefulWidget {
  const EditExperimentPage({super.key, required this.experiment});

  final ExperimentEntity experiment;

  @override
  State<EditExperimentPage> createState() => _EditExperimentPageState();
}

class _EditExperimentPageState extends State<EditExperimentPage> {
  late final EditExperimentViewmodel _editExperimentViewmodel;
  late final TreatmentsViewmodel _treatmentsViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _repetitionsController;

  late final GroupButtonController _treatmentsController;
  final List<TreatmentEntity> _selectedTreatments = [];

  late final GroupButtonController _enzymesController;
  final List<EnzymeEntity> _selectedEnzymes = [];

  final Map<String, TextEditingController> _enzymeFieldControllers = {};

  @override
  void initState() {
    super.initState();
    _editExperimentViewmodel = GetIt.I.get<EditExperimentViewmodel>();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();

    _nameController = TextEditingController(text: widget.experiment.name);
    _descriptionController = TextEditingController(text: widget.experiment.description);
    _repetitionsController = TextEditingController(text: widget.experiment.repetitions.toString());

    _treatmentsController = GroupButtonController();
    _enzymesController = GroupButtonController();

    _initTreatmentsSelection();
    _initEnzymesSelection();

    _editExperimentViewmodel.addListener(_onViewmodelChanged);
  }

  @override
  void dispose() {
    _editExperimentViewmodel.removeListener(_onViewmodelChanged);
    _nameController.dispose();
    _descriptionController.dispose();
    _repetitionsController.dispose();
    for (final controller in _enzymeFieldControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onViewmodelChanged() {
    if (!mounted) return;

    if (_editExperimentViewmodel.state == StateEnum.error) {
      EZTSnackBar.show(
        context,
        HandleFailure.of(context.l10n, _editExperimentViewmodel.failure!),
        eztSnackBarType: EZTSnackBarType.error,
      );
      return;
    }

    final updated = _editExperimentViewmodel.updatedExperiment;
    if (_editExperimentViewmodel.state == StateEnum.success && updated != null) {
      GetIt.I.get<ExperimentDetailsViewmodel>().setExperiment(updated);
      Navigator.pop(context);
      EZTSnackBar.show(context, context.l10n.experimentUpdatedSuccess, eztSnackBarType: EZTSnackBarType.success);
    }
  }

  void _initTreatmentsSelection() {
    for (final current in widget.experiment.treatments ?? <TreatmentEntity>[]) {
      final matches = _treatmentsViewmodel.treatments.where((t) => t.id == current.sourceTreatmentId).toList();
      if (matches.isEmpty) continue;

      final globalTreatment = matches.first;
      final index = _treatmentsViewmodel.treatments.indexOf(globalTreatment);
      _treatmentsController.selectIndex(index);
      _selectedTreatments.add(globalTreatment);
    }
  }

  void _initEnzymesSelection() {
    for (final current in widget.experiment.enzymes ?? <EnzymeEntity>[]) {
      final matches = _enzymesViewmodel.enzymes.where((e) => e.id == current.sourceEnzymeId).toList();
      if (matches.isEmpty) continue;

      final globalEnzyme = matches.first;
      final index = _enzymesViewmodel.enzymes.indexOf(globalEnzyme);
      _enzymesController.selectIndex(index);
      _selectedEnzymes.add(globalEnzyme);

      _durationControllerFor(globalEnzyme.id).text = current.duration?.toString() ?? '';
      _weightSampleControllerFor(globalEnzyme.id).text = current.weightSample?.toString() ?? '';
      _weightGroundControllerFor(globalEnzyme.id).text = current.weightGround?.toString() ?? '';
      _sizeControllerFor(globalEnzyme.id).text = current.size?.toString() ?? '';
    }
  }

  TextEditingController _durationControllerFor(String enzymeId) =>
      _enzymeFieldControllers.putIfAbsent('duration-$enzymeId', () => TextEditingController());

  TextEditingController _weightSampleControllerFor(String enzymeId) =>
      _enzymeFieldControllers.putIfAbsent('weightSample-$enzymeId', () => TextEditingController());

  TextEditingController _weightGroundControllerFor(String enzymeId) =>
      _enzymeFieldControllers.putIfAbsent('weightGround-$enzymeId', () => TextEditingController());

  TextEditingController _sizeControllerFor(String enzymeId) =>
      _enzymeFieldControllers.putIfAbsent('size-$enzymeId', () => TextEditingController());

  bool get _allEnzymeConfigFieldsFilled {
    for (final enzyme in _selectedEnzymes) {
      if (_durationControllerFor(enzyme.id).text.isEmpty) return false;
      if (_weightSampleControllerFor(enzyme.id).text.isEmpty) return false;
      if (_weightGroundControllerFor(enzyme.id).text.isEmpty) return false;
      if (_sizeControllerFor(enzyme.id).text.isEmpty) return false;
    }
    return true;
  }

  bool get _canSave =>
      _nameController.text.isNotEmpty &&
      _descriptionController.text.isNotEmpty &&
      _repetitionsController.text.isNotEmpty &&
      _selectedTreatments.isNotEmpty &&
      _selectedEnzymes.isNotEmpty &&
      _allEnzymeConfigFieldsFilled;

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_canSave) return;

    final enzymes = _selectedEnzymes
        .map(
          (enzyme) => EnzymeDto.toExperimetEnzyme(
            enzyme,
            duration: int.parse(_durationControllerFor(enzyme.id).text),
            weightSample: double.parse(_weightSampleControllerFor(enzyme.id).text),
            weightGround: double.parse(_weightGroundControllerFor(enzyme.id).text),
            size: double.parse(_sizeControllerFor(enzyme.id).text),
          ),
        )
        .toList();

    await _editExperimentViewmodel.save(
      experimentId: widget.experiment.id,
      name: _nameController.text,
      description: _descriptionController.text,
      repetitions: int.parse(_repetitionsController.text),
      treatmentsIDs: _selectedTreatments.map((t) => t.id).toList(),
      enzymes: enzymes,
    );
  }

  Widget get _basicInfoSection {
    final requiredValidator = FieldValidator([ValidateRule(ValidateTypes.required)], context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(PhosphorIcons.flask()),
            const SizedBox(width: 4),
            Text(context.l10n.experimentIdentification, style: TextStyles.detailBold),
          ],
        ),
        const SizedBox(height: 8),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.nameLabel,
          usePrimaryColorOnFocusedBorder: true,
          controller: _nameController,
          fieldValidator: requiredValidator,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.descriptionLabel,
          usePrimaryColorOnFocusedBorder: true,
          controller: _descriptionController,
          fieldValidator: requiredValidator,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: context.l10n.repetitionsPerTreatmentLabel,
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.number,
          controller: _repetitionsController,
          fieldValidator: FieldValidator([
            ValidateRule(ValidateTypes.required),
            ValidateRule(ValidateTypes.greaterThanZero),
          ], context),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget get _treatmentsSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            Icon(PhosphorIcons.testTube()),
            const SizedBox(width: 4),
            Text(context.l10n.treatmentsAndRepetitionsData, style: TextStyles.detailBold),
          ],
        ),
        Visibility(
          visible: _treatmentsViewmodel.treatments.isNotEmpty,
          replacement: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: EZTError(message: context.l10n.noTreatmentsRegisteredError),
          ),
          child: GroupButton(
            controller: _treatmentsController,
            isRadio: false,
            options: const GroupButtonOptions(groupingType: GroupingType.column),
            buttons: _treatmentsViewmodel.treatments.map((t) => t.name).toList(),
            buttonIndexedBuilder: (selected, index, context) {
              final treatment = _treatmentsViewmodel.treatments[index];
              return EZTCheckBoxTile(
                title: treatment.name,
                selected: selected,
                onTap: () {
                  setState(() {
                    if (!selected) {
                      _treatmentsController.selectIndex(index);
                      _selectedTreatments.add(treatment);
                    } else {
                      _treatmentsController.unselectIndex(index);
                      _selectedTreatments.remove(treatment);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget get _enzymesSection {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Row(
          children: [
            Icon(PhosphorIcons.flask()),
            const SizedBox(width: 4),
            Text(context.l10n.experimentEnzymes, style: TextStyles.detailBold),
          ],
        ),
        GroupButton(
          controller: _enzymesController,
          isRadio: false,
          options: const GroupButtonOptions(groupingType: GroupingType.column),
          buttons: _enzymesViewmodel.enzymes.map((e) => e.name).toList(),
          buttonIndexedBuilder: (selected, index, context) {
            final enzyme = _enzymesViewmodel.enzymes[index];
            return EZTCheckBoxTile(
              title: enzyme.name,
              selected: selected,
              color: Constants.dealWithEnzymeChipColor(enzyme.type),
              onTap: () {
                setState(() {
                  if (!selected) {
                    _enzymesController.selectIndex(index);
                    _selectedEnzymes.add(enzyme);
                  } else {
                    _enzymesController.unselectIndex(index);
                    _selectedEnzymes.remove(enzyme);
                  }
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _enzymeConfigCard(EnzymeEntity enzyme) {
    final requiredNumberValidator = FieldValidator([
      ValidateRule(ValidateTypes.required),
      ValidateRule(ValidateTypes.greaterThanZeroDecimal),
    ], context);
    final requiredIntegerValidator = FieldValidator([
      ValidateRule(ValidateTypes.required),
      ValidateRule(ValidateTypes.isInteger),
    ], context);

    return Card(
      margin: const EdgeInsets.only(top: 16),
      color: context.getApplyedColorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(enzyme.name, style: TextStyles.detailBold),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: EZTTextField(
                    eztTextFieldType: EZTTextFieldType.underline,
                    labelText: context.l10n.timeHours,
                    usePrimaryColorOnFocusedBorder: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    controller: _durationControllerFor(enzyme.id),
                    fieldValidator: requiredIntegerValidator,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EZTTextField(
                    eztTextFieldType: EZTTextFieldType.underline,
                    labelText: context.l10n.solutionVolume,
                    usePrimaryColorOnFocusedBorder: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _sizeControllerFor(enzyme.id),
                    fieldValidator: requiredNumberValidator,
                    inputFormatters: Constants.enzymeDecimalInputFormatters,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: EZTTextField(
                    eztTextFieldType: EZTTextFieldType.underline,
                    labelText: context.l10n.sampleWeightGrams,
                    usePrimaryColorOnFocusedBorder: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _weightSampleControllerFor(enzyme.id),
                    fieldValidator: requiredNumberValidator,
                    inputFormatters: Constants.enzymeDecimalInputFormatters,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: EZTTextField(
                    eztTextFieldType: EZTTextFieldType.underline,
                    labelText: context.l10n.correctionFactor,
                    usePrimaryColorOnFocusedBorder: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    controller: _weightGroundControllerFor(enzyme.id),
                    fieldValidator: requiredNumberValidator,
                    inputFormatters: Constants.enzymeDecimalInputFormatters,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _enzymeConfigSection {
    if (_selectedEnzymes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Text(context.l10n.otherVariables, style: TextStyles.detailBold),
        ..._selectedEnzymes.map(_enzymeConfigCard),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _editExperimentViewmodel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: context.getApplyedColorScheme.onSurface),
            title: Text(context.l10n.editExperimentTitle, style: TextStyles(context).titleBoldBackground()),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    _basicInfoSection,
                    _treatmentsSection,
                    _enzymesSection,
                    _enzymeConfigSection,
                    const SizedBox(height: 32),
                    EZTButton(
                      enabled: _canSave,
                      text: context.l10n.saveChangesButton,
                      loading: _editExperimentViewmodel.state == StateEnum.loading,
                      onPressed: _onSave,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
