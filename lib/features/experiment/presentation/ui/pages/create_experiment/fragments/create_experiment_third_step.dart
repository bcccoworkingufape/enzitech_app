// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../../shared/utils/utils.dart';
import '../../../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../../../../enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../../dto/create_experiment_dto.dart';
import '../../../../viewmodel/create_experiment_viewmodel.dart';
import '../create_experiment_fragment_template.dart';

class CreateExperimentThirdStepPage extends StatefulWidget {
  const CreateExperimentThirdStepPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateExperimentThirdStepPage> createState() =>
      _CreateExperimentThirdStepPageState();
}

class _CreateExperimentThirdStepPageState
    extends State<CreateExperimentThirdStepPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;

  late GroupButtonController _checkboxesController;
  late final _checkboxButtons = [];
  final _choosedCheckboxList = <EnzymeEntity>[];

  @override
  void initState() {
    super.initState();
    _createExperimentViewmodel = GetIt.I.get<CreateExperimentViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();

    for (var enzyme in _enzymesViewmodel.enzymes) {
      _checkboxButtons.add(enzyme.name);
    }

    _checkboxesController = GroupButtonController();

    Future.delayed(const Duration(milliseconds: 1))
        .whenComplete(() => _validateFields);

    _initFields();
  }

  void _initFields() {
    var tempEnz = _createExperimentViewmodel.temporaryExperiment.enzymes ?? [];

    if (tempEnz.isNotEmpty) {
      for (var enz in tempEnz) {
        _checkboxesController.selectIndex(_enzymesViewmodel.enzymes.indexOf(
            _enzymesViewmodel.enzymes.firstWhere((e) => e.id == enz.id)));

        _choosedCheckboxList
            .add(_enzymesViewmodel.enzymes.firstWhere((e) => e.id == enz.id));
      }
    }

    setState(() {});
  }

  get _validateFields {
    if (_choosedCheckboxList.isNotEmpty) {
      setState(() {
        // print(_createExperimentViewmodel.formKey.currentState!.validate());
        _createExperimentViewmodel.setEnableNextButtonOnThirdStep(true);
      });
    } else {
      setState(() {
        _createExperimentViewmodel.setEnableNextButtonOnThirdStep(false);
      });
    }
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _createExperimentViewmodel.enableNextButtonOnThirdStep,
          text: 'Próximo',
          onPressed: () {
            _createExperimentViewmodel.formKey.currentState!.save();

            if (_createExperimentViewmodel.formKey.currentState!.validate()) {
              var temporary = _createExperimentViewmodel.temporaryExperiment;

              _createExperimentViewmodel.setTemporaryExperiment(
                CreateExperimentDTO(
                  name: temporary.name,
                  description: temporary.description,
                  enzymes: _choosedCheckboxList,
                  repetitions: temporary.repetitions,
                  treatmentsIDs: temporary.treatmentsIDs,
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
      messageOfStepIndicator: "Etapa 3 de 4 - Enzimas",
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
            Row(
              children: [
                const Icon(
                  PhosphorIcons.flask,
                  // color: AppColors.greySweet, //TODO: COLOR-FIX
                ),
                const SizedBox(width: 4),
                Text(
                  'Enzimas do experimento',
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
                      _choosedCheckboxList
                          .add(_enzymesViewmodel.enzymes[index]);
                      setState(() {
                        _createExperimentViewmodel
                            .setEnableNextButtonOnThirdStep(
                                _choosedCheckboxList.isNotEmpty);
                      });

                      return;
                    }
                    _checkboxesController.unselectIndex(index);
                    _choosedCheckboxList
                        .remove(_enzymesViewmodel.enzymes[index]);
                    setState(() {
                      _createExperimentViewmodel.setEnableNextButtonOnThirdStep(
                          _choosedCheckboxList.isNotEmpty);
                    });
                  },
                  color: Constants.dealWithEnzymeChipColor(
                      _enzymesViewmodel.enzymes[index].type),
                  onTapTrailing: () {
                    EZTSnackBar.clear(context);
                    EZTSnackBar.show(
                      context,
                      "Tipo da enzima: ${Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(_enzymesViewmodel.enzymes[index].type)]}",
                      color: Constants.dealWithEnzymeChipColor(
                        _enzymesViewmodel.enzymes[index].type,
                      ),
                      textStyle: TextStyles.titleMinBoldBackground,
                      centerTitle: true,
                    );
                  },
                );
              },
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
