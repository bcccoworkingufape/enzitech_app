// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
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

  late final GroupButtonController _treatmentsController;
  final List<TreatmentEntity> _selectedTreatments = [];

  late final GroupButtonController _enzymesController;
  final List<EnzymeEntity> _selectedEnzymes = [];

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();

    _treatmentsController = GroupButtonController();
    _enzymesController = GroupButtonController();

    _initSelection();
  }

  void _initSelection() {
    final chosen = _calculateExperimentViewmodel.temporaryChoosedExperimentCombination;
    final treatments = _calculateExperimentViewmodel.experiment.treatments ?? [];
    final enzymes = _calculateExperimentViewmodel.experiment.enzymes ?? [];

    for (final treatment in chosen.treatments) {
      final index = treatments.indexWhere((t) => t.id == treatment.id);
      if (index == -1) continue;
      _treatmentsController.selectIndex(index);
      _selectedTreatments.add(treatment);
    }

    for (final enzyme in chosen.enzymes) {
      final index = enzymes.indexWhere((e) => e.id == enzyme.id);
      if (index == -1) continue;
      _enzymesController.selectIndex(index);
      _selectedEnzymes.add(enzyme);
    }

    _validateFields();
  }

  void _validateFields() {
    setState(() {
      _calculateExperimentViewmodel.setEnableNextButtonOnFirstStep(
        _selectedTreatments.isNotEmpty && _selectedEnzymes.isNotEmpty,
      );
    });
  }

  Widget get _treatmentsSection {
    final treatments = _calculateExperimentViewmodel.experiment.treatments ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.selectTreatment, style: TextStyles.detailBold),
        const SizedBox(height: 8),
        GroupButton(
          controller: _treatmentsController,
          isRadio: false,
          options: const GroupButtonOptions(groupingType: GroupingType.column),
          buttons: treatments.map((t) => t.name).toList(),
          buttonIndexedBuilder: (selected, index, context) {
            final treatment = treatments[index];
            return EZTCheckBoxTile(
              title: treatment.name,
              selected: selected,
              onTap: () {
                if (!selected) {
                  _treatmentsController.selectIndex(index);
                  _selectedTreatments.add(treatment);
                } else {
                  _treatmentsController.unselectIndex(index);
                  _selectedTreatments.remove(treatment);
                }
                _validateFields();
              },
            );
          },
        ),
      ],
    );
  }

  Widget get _enzymesSection {
    final enzymes = _calculateExperimentViewmodel.experiment.enzymes ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.selectEnzyme, style: TextStyles.detailBold),
        const SizedBox(height: 8),
        GroupButton(
          controller: _enzymesController,
          isRadio: false,
          options: const GroupButtonOptions(groupingType: GroupingType.column),
          buttons: enzymes.map((e) => e.name).toList(),
          buttonIndexedBuilder: (selected, index, context) {
            final enzyme = enzymes[index];
            return EZTCheckBoxTile(
              title: enzyme.name,
              selected: selected,
              color: Constants.dealWithEnzymeChipColor(enzyme.type),
              onTap: () {
                if (!selected) {
                  _enzymesController.selectIndex(index);
                  _selectedEnzymes.add(enzyme);
                } else {
                  _enzymesController.unselectIndex(index);
                  _selectedEnzymes.remove(enzyme);
                }
                _validateFields();
              },
              onTapTrailing: () {
                EZTSnackBar.clear(context);
                EZTSnackBar.show(
                  context,
                  context.l10n.selectedEnzymeType(
                    Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(enzyme.type)],
                  ),
                  color: Constants.dealWithEnzymeChipColor(enzyme.type),
                  textStyle: TextStyles(context).titleMinBoldBackground(),
                  centerTitle: true,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnFirstStep,
          text: context.l10n.nextButton,
          loading: _calculateExperimentViewmodel.state == StateEnum.loading,
          onPressed: () async {
            _calculateExperimentViewmodel.setTemporaryChoosedExperimentCombination(
              ChoosedExperimentCombinationDTO(enzymes: _selectedEnzymes, treatments: _selectedTreatments),
            );

            await _calculateExperimentViewmodel.fetchRepetitions().whenComplete(() {
              if (!mounted) return;
              _calculateExperimentViewmodel.onNext(context);
            });
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
          messageOfStepIndicator: context.l10n.stepIndicatorMessage(1, 2),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Visibility(
                  visible:
                      (_calculateExperimentViewmodel.experiment.treatments ?? []).isNotEmpty &&
                      (_calculateExperimentViewmodel.experiment.enzymes ?? []).isNotEmpty,
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
                      _treatmentsSection,
                      const SizedBox(height: 24),
                      _enzymesSection,
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
