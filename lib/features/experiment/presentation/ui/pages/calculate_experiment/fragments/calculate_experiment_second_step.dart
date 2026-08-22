// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/routing/routing.dart';
import '../../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../../shared/extensions/num_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../../shared/validator/security_validators.dart';
import '../../../../../../../shared/validator/validator.dart';
import '../../../../../domain/entities/repetition_entity.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class CalculateExperimentSecondStepPage extends StatefulWidget {
  const CalculateExperimentSecondStepPage({super.key});

  @override
  State<CalculateExperimentSecondStepPage> createState() => _CalculateExperimentSecondStepPageState();
}

class _CalculateExperimentSecondStepPageState extends State<CalculateExperimentSecondStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;

  final Map<String, TextEditingController> _sampleControllers = {};
  final Map<String, TextEditingController> _whiteSampleControllers = {};
  String? _expandedRepetitionId;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
  }

  @override
  void dispose() {
    for (final controller in _sampleControllers.values) {
      controller.dispose();
    }
    for (final controller in _whiteSampleControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _sampleControllerFor(String repetitionId) =>
      _sampleControllers.putIfAbsent(repetitionId, () => TextEditingController());

  TextEditingController _whiteSampleControllerFor(String repetitionId) =>
      _whiteSampleControllers.putIfAbsent(repetitionId, () => TextEditingController());

  bool _canCalculate(String repetitionId) {
    final sample = double.tryParse(_sampleControllerFor(repetitionId).text);
    final whiteSample = double.tryParse(_whiteSampleControllerFor(repetitionId).text);
    return sample != null && sample > 0 && whiteSample != null && whiteSample > 0;
  }

  Future<void> _onCalculate(RepetitionEntity repetition) async {
    final sample = double.parse(_sampleControllerFor(repetition.id).text);
    final whiteSample = double.parse(_whiteSampleControllerFor(repetition.id).text);

    await _calculateExperimentViewmodel.previewRepetition(
      treatmentId: repetition.treatmentId,
      enzymeId: repetition.enzymeId,
      repetitionNumber: repetition.repetitionNumber,
      sample: sample,
      whiteSample: whiteSample,
    );
  }

  Future<void> _onSave(RepetitionEntity repetition) async {
    final sample = double.parse(_sampleControllerFor(repetition.id).text);
    final whiteSample = double.parse(_whiteSampleControllerFor(repetition.id).text);

    await _calculateExperimentViewmodel.saveRepetition(
      treatmentId: repetition.treatmentId,
      enzymeId: repetition.enzymeId,
      repetitionNumber: repetition.repetitionNumber,
      sample: sample,
      whiteSample: whiteSample,
    );

    if (!mounted) return;

    if (_calculateExperimentViewmodel.state != StateEnum.error) {
      setState(() {
        _expandedRepetitionId = null;
      });

      EZTSnackBar.clear(context);
      EZTSnackBar.show(context, context.l10n.repetitionSavedMessage, eztSnackBarType: EZTSnackBarType.success);
    }
  }

  Widget _statusChip(RepetitionEntity repetition) {
    return Chip(
      label: Text(repetition.isCompleted ? context.l10n.completed : context.l10n.pending),
      backgroundColor: repetition.isCompleted
          ? context.getApplyedColorScheme.primaryContainer
          : context.getApplyedColorScheme.surface,
    );
  }

  Widget _completedSummary(RepetitionEntity repetition) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${context.l10n.sample}: ${repetition.sample?.formmatedNumber}'),
          Text('${context.l10n.whiteSample}: ${repetition.whiteSample?.formmatedNumber}'),
          Text('${context.l10n.columnCurve}: ${repetition.curve?.formmatedNumber}'),
          Text('${context.l10n.columnResult}: ${repetition.result?.formmatedNumber}'),
        ],
      ),
    );
  }

  Widget _pendingForm(RepetitionEntity repetition) {
    final preview = _calculateExperimentViewmodel.previewedRepetition;
    final showingPreviewForThisRepetition = preview != null && preview.id == repetition.id;
    final fieldValidator = FieldValidator(SecurityValidators.absorbance(), context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EZTTextField(
            eztTextFieldType: EZTTextFieldType.underline,
            labelText: context.l10n.sample,
            usePrimaryColorOnFocusedBorder: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _sampleControllerFor(repetition.id),
            inputFormatters: Constants.enzymeDecimalInputFormatters,
            fieldValidator: fieldValidator,
            onChanged: (_) {
              _calculateExperimentViewmodel.setPreviewedRepetition(null);
              setState(() {});
            },
          ),
          const SizedBox(height: 10),
          EZTTextField(
            eztTextFieldType: EZTTextFieldType.underline,
            labelText: context.l10n.whiteSample,
            usePrimaryColorOnFocusedBorder: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: _whiteSampleControllerFor(repetition.id),
            inputFormatters: Constants.enzymeDecimalInputFormatters,
            fieldValidator: fieldValidator,
            onChanged: (_) {
              _calculateExperimentViewmodel.setPreviewedRepetition(null);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          if (showingPreviewForThisRepetition)
            Card(
              margin: EdgeInsets.zero,
              color: context.getApplyedColorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${context.l10n.columnCurve}: ${preview.curve?.formmatedNumber}'),
                    Text('${context.l10n.columnResult}: ${preview.result?.formmatedNumber}'),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          EZTButton(
            text: showingPreviewForThisRepetition ? context.l10n.saveRepetitionButton : context.l10n.calculateButton,
            loading: _calculateExperimentViewmodel.state == StateEnum.loading,
            enabled: _canCalculate(repetition.id),
            onPressed: showingPreviewForThisRepetition ? () => _onSave(repetition) : () => _onCalculate(repetition),
          ),
        ],
      ),
    );
  }

  Widget _repetitionTile(RepetitionEntity repetition) {
    return EZTExpansionTile(
      key: ValueKey(repetition.id),
      initiallyExpanded: _expandedRepetitionId == repetition.id,
      onExpansionChanged: (expanded) {
        setState(() {
          _expandedRepetitionId = expanded ? repetition.id : null;
        });
        if (expanded) _calculateExperimentViewmodel.setPreviewedRepetition(null);
      },
      title: Text(context.l10n.repetitionDataTitle(repetition.repetitionNumber)),
      trailing: _statusChip(repetition),
      children: [repetition.isCompleted ? _completedSummary(repetition) : _pendingForm(repetition)],
    );
  }

  Widget _combinationSection(String title, List<RepetitionEntity> repetitions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title, style: TextStyles.detailBold),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: repetitions.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _repetitionTile(repetitions[index]),
        ),
      ],
    );
  }

  List<Widget> _combinationSections(List<RepetitionEntity> repetitions) {
    final grouped = <String, List<RepetitionEntity>>{};

    for (final repetition in repetitions) {
      final key = '${repetition.treatmentId}|${repetition.enzymeId}';
      grouped.putIfAbsent(key, () => []).add(repetition);
    }

    return grouped.values.map((group) {
      final first = group.first;
      return _combinationSection('${first.treatmentName} — ${first.enzymeName}', group);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _calculateExperimentViewmodel,
      builder: (context, child) {
        final repetitions = _calculateExperimentViewmodel.repetitionsForChosenCombination;
        final loadingRepetitions = _calculateExperimentViewmodel.state == StateEnum.loading && repetitions.isEmpty;

        return CalculateExperimentFragmentTemplate(
          titleOfStepIndicator: context.l10n.insertExperimentData,
          messageOfStepIndicator: context.l10n.stepIndicatorMessageFilling(2, 2),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(PhosphorIcons.flask()),
                    const SizedBox(width: 4),
                    Expanded(child: Text(context.l10n.fillRepetitionsTitle, style: TextStyles.detailBold)),
                  ],
                ),
                if (loadingRepetitions)
                  const Padding(padding: EdgeInsets.symmetric(vertical: 32), child: EZTProgressIndicator())
                else
                  ..._combinationSections(repetitions),
                const SizedBox(height: 64),
                EZTButton(
                  text: context.l10n.finishButton,
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName(Routing.experimentDetailed));
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
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
