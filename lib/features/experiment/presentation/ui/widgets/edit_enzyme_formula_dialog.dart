// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../core/enums/enums.dart';
import '../../../../../shared/extensions/extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../viewmodel/experiment_details_viewmodel.dart';

const _curveVariables = ['difference', 'variableA', 'variableB'];
const _calculationVariables = ['curve', 'size', 'duration', 'weightSample', 'weightGround'];

class EditEnzymeFormulaDialog extends StatefulWidget {
  const EditEnzymeFormulaDialog({super.key, required this.enzyme});

  final EnzymeEntity enzyme;

  @override
  State<EditEnzymeFormulaDialog> createState() => _EditEnzymeFormulaDialogState();
}

class _EditEnzymeFormulaDialogState extends State<EditEnzymeFormulaDialog> {
  late final ExperimentDetailsViewmodel _experimentDetailsViewmodel;

  late final TextEditingController _curveController;
  late final TextEditingController _calculationController;

  @override
  void initState() {
    super.initState();
    _experimentDetailsViewmodel = GetIt.I.get<ExperimentDetailsViewmodel>();

    _curveController = TextEditingController(
      text: widget.enzyme.customFormulaCurve ?? widget.enzyme.formulaCurve ?? '',
    );
    _calculationController = TextEditingController(
      text: widget.enzyme.customFormulaCalculation ?? widget.enzyme.formulaCalculation ?? '',
    );

    _experimentDetailsViewmodel.addListener(_onViewmodelChanged);
  }

  @override
  void dispose() {
    _experimentDetailsViewmodel.removeListener(_onViewmodelChanged);
    _curveController.dispose();
    _calculationController.dispose();
    super.dispose();
  }

  void _onViewmodelChanged() {
    if (!mounted) return;

    if (_experimentDetailsViewmodel.state == StateEnum.success) {
      Navigator.of(context).pop();
      EZTSnackBar.show(context, context.l10n.formulaUpdatedSuccess, eztSnackBarType: EZTSnackBarType.success);
    }
  }

  static bool _isWordChar(String char) => RegExp(r'[A-Za-z0-9_]').hasMatch(char);

  void _insertVariable(TextEditingController controller, String variable) {
    final text = controller.text;
    final selection = controller.selection;
    final start = (selection.start >= 0 ? selection.start : text.length).clamp(0, text.length);
    final end = (selection.end >= 0 ? selection.end : text.length).clamp(0, text.length);

    final before = text.substring(0, start);
    final after = text.substring(end);

    // Evita colar a variável em outro identificador já existente (ex.: "variableAdifference"),
    // que o motor de fórmulas interpretaria como multiplicação implícita ("variableA * difference").
    final needsSpaceBefore = before.isNotEmpty && _isWordChar(before[before.length - 1]);
    final needsSpaceAfter = after.isNotEmpty && _isWordChar(after[0]);

    final insertion = '${needsSpaceBefore ? ' ' : ''}$variable${needsSpaceAfter ? ' ' : ''}';
    final newText = before + insertion + after;
    final cursorOffset = before.length + insertion.length - (needsSpaceAfter ? 1 : 0);

    setState(() {
      controller.text = newText;
      controller.selection = TextSelection.collapsed(offset: cursorOffset);
    });
  }

  Widget _descriptionBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.getApplyedColorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(PhosphorIcons.info(), size: 18, color: context.getApplyedColorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.editEnzymeFormulaDescription,
              style: TextStyles.bodyMinRegular.copyWith(color: context.getApplyedColorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  // Nome amigável e traduzido de cada variável, exibido no chip — o identificador técnico
  // (necessário para a fórmula) continua sendo inserido no campo e fica visível no tooltip.
  String _variableLabel(String variable) {
    switch (variable) {
      case 'difference':
        return context.l10n.formulaVariable_difference;
      case 'variableA':
        return context.l10n.formulaVariable_variableA;
      case 'variableB':
        return context.l10n.formulaVariable_variableB;
      case 'curve':
        return context.l10n.formulaVariable_curve;
      case 'size':
        return context.l10n.solutionVolume;
      case 'duration':
        return context.l10n.timeHours;
      case 'weightSample':
        return context.l10n.sampleWeightGrams;
      case 'weightGround':
        return context.l10n.correctionFactor;
      default:
        return variable;
    }
  }

  Widget _variableChip(TextEditingController controller, String variable) {
    return Tooltip(
      message: variable,
      child: ActionChip(
        avatar: Icon(PhosphorIcons.plusCircle(), size: 14, color: context.getApplyedColorScheme.primary),
        label: Text(_variableLabel(variable), style: TextStyles.bodyMinRegular.copyWith(fontSize: 12)),
        visualDensity: VisualDensity.compact,
        backgroundColor: context.getApplyedColorScheme.primaryContainer.withValues(alpha: 0.3),
        side: BorderSide.none,
        onPressed: () => _insertVariable(controller, variable),
      ),
    );
  }

  Widget _formulaSection({
    required IconData icon,
    required String label,
    required List<String> variables,
    required TextEditingController controller,
    required String? defaultFormula,
  }) {
    final isCustomized = controller.text.trim() != (defaultFormula ?? '').trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: context.getApplyedColorScheme.primary),
            const SizedBox(width: 6),
            Text(label, style: TextStyles.bodyMinBold),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: context.getApplyedColorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: context.getApplyedColorScheme.outlineVariant),
          ),
          child: TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
            decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            onChanged: (_) => setState(() {}),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.l10n.tapVariableToInsert,
          style: TextStyles.bodyMinRegular.copyWith(color: context.getApplyedColorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 6),
        Wrap(spacing: 6, runSpacing: 6, children: variables.map((v) => _variableChip(controller, v)).toList()),
        if (isCustomized)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => setState(() => controller.text = defaultFormula ?? ''),
              icon: Icon(PhosphorIcons.arrowCounterClockwise(), size: 16),
              label: Text(context.l10n.restoreDefaultFormulaButton),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _experimentDetailsViewmodel,
      builder: (context, child) {
        final loading = _experimentDetailsViewmodel.state == StateEnum.loading;

        return AlertDialog(
          title: Row(
            children: [
              Icon(PhosphorIcons.sigma(), color: context.getApplyedColorScheme.primary),
              const SizedBox(width: 8),
              Expanded(child: Text(context.l10n.editEnzymeFormulaTitle)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: context.getApplyedColorScheme.secondaryContainer.withValues(alpha: 0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIcons.flask(), size: 14, color: context.getApplyedColorScheme.primary),
                      const SizedBox(width: 6),
                      Text(widget.enzyme.name, style: TextStyles.bodyMinBold),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _descriptionBox(),
                const SizedBox(height: 20),
                _formulaSection(
                  icon: PhosphorIcons.chartLineUp(),
                  label: context.l10n.curveFormulaLabel,
                  variables: _curveVariables,
                  controller: _curveController,
                  defaultFormula: widget.enzyme.formulaCurve,
                ),
                const SizedBox(height: 20),
                _formulaSection(
                  icon: PhosphorIcons.calculator(),
                  label: context.l10n.calculationFormulaLabel,
                  variables: _calculationVariables,
                  controller: _calculationController,
                  defaultFormula: widget.enzyme.formulaCalculation,
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.of(context).pop(),
              child: Text(context.l10n.cancelButton),
            ),
            EZTButton(
              text: context.l10n.saveFormulaButton,
              loading: loading,
              onPressed: () {
                _experimentDetailsViewmodel.updateEnzymeFormula(
                  experimentEnzymeId: widget.enzyme.id,
                  customFormulaCurve: _curveController.text,
                  customFormulaCalculation: _calculationController.text,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
