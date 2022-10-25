// 🐦 Flutter imports:
// ignore_for_file: avoid_function_literals_in_foreach_calls

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/ezt_create_experiment_step_indicator.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/shared/models_/enzyme_model.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_checkbox_tile.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/utilities/util/constants.dart';
import 'package:enzitech_app/src/shared/utilities/util/util.dart';

class CreateExperimentThirdStepPage extends StatefulWidget {
  const CreateExperimentThirdStepPage({
    Key? key,
    required this.callback,
    required this.formKey,
  }) : super(key: key);

  final void Function({int page}) callback;
  final GlobalKey<FormState> formKey;

  @override
  State<CreateExperimentThirdStepPage> createState() =>
      _CreateExperimentThirdStepPageState();
}

class _CreateExperimentThirdStepPageState
    extends State<CreateExperimentThirdStepPage> {
  late final CreateExperimentController controller;
  late final EnzymesController enzymesController;

  late GroupButtonController _checkboxesController;
  late final _checkboxButtons = [];
  final _choosedCheckboxList = <EnzymeModel>[];

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();
    enzymesController = context.read<EnzymesController>();

    Future.delayed(Duration.zero, () async {
      enzymesController.loadEnzymes().whenComplete(
            () => enzymesController.enzymes.forEach(
              (enz) {
                _checkboxButtons.add(enz.name);
              },
            ),
          );
    });

    _checkboxesController = GroupButtonController();

    super.initState();
  }

  bool enableNextButton = false;

  Widget get _body {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          const EZTCreateExperimentStepIndicator(
            title: "Cadastre um novo experimento",
            message: "Etapa 3 de 4 - Enzimas",
          ),
          const SizedBox(
            height: 64,
          ),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greySweet,
              ),
              const SizedBox(width: 4),
              Text(
                'Enzimas',
                style: TextStyles.detailBold,
              ),
            ],
          ),
          Visibility(
            visible: enzymesController.state == EnzymesState.loading,
            replacement: GroupButton(
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
                          .add(enzymesController.enzymes[index]);
                      setState(() {
                        enableNextButton = _choosedCheckboxList.isNotEmpty;
                      });

                      return;
                    }
                    _checkboxesController.unselectIndex(index);
                    _choosedCheckboxList
                        .remove(enzymesController.enzymes[index]);
                    setState(() {
                      enableNextButton = _choosedCheckboxList.isNotEmpty;
                    });
                  },
                  color: Constants.dealWithEnzymeChipColor(
                      enzymesController.enzymes[index].type),
                  onTapTrailing: () {
                    EZTSnackBar.clear(context);
                    EZTSnackBar.show(
                      context,
                      "Tipo da enzima: ${Constants.typesOfEnzymesListFormmated[Constants.typesOfEnzymesList.indexOf(enzymesController.enzymes[index].type)]}",
                      color: Constants.dealWithEnzymeChipColor(
                        enzymesController.enzymes[index].type,
                      ),
                      textStyle: TextStyles.titleMinBoldBackground,
                      centerTitle: true,
                    );
                  },
                );
              },
            ),
            child: Padding(
              padding: const EdgeInsets.all(64),
              child: Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 24,
                  ),
                  Text("Carregando enzimas..."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _buttons {
    var choosedCheckboxListFormatted = [];
    _choosedCheckboxList.forEach((element) {
      choosedCheckboxListFormatted.add(element.toMap());
    });

    return Column(
      children: [
        EZTButton(
          enabled: enableNextButton,
          text: 'Próximo',
          onPressed: () {
            widget.formKey.currentState!.save();
            controller.experimentRequestModel.experimentsEnzymes =
                _choosedCheckboxList;

            controller
                .setExperimentRequestModel(controller.experimentRequestModel);

            controller.pageController.nextPage(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            widget.callback(page: 1);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CreateExperimentController>();
    context.watch<EnzymesController>();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 11,
            child: Center(child: _body),
          ),
          SizedBox(
            height: 160,
            child: Padding(
              padding: Constants.padding16all,
              child: _buttons,
            ),
          ),
        ],
      ),
    );
  }
}
