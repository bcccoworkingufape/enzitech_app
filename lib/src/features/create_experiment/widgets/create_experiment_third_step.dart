// 🐦 Flutter imports:
import 'dart:developer';

import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:group_button/group_button.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:provider/provider.dart';
import '../../../shared/themes/app_complete_theme.dart';
import '../../../shared/util/constants.dart';
import '../../../shared/util/util.dart';
import '../../../shared/widgets/ezt_button.dart';
import '../../../shared/widgets/ezt_checkbox_tile.dart';

class CreateExperimentThirdStepPage extends StatefulWidget {
  const CreateExperimentThirdStepPage({
    Key? key,
    // required this.pageController,
    required this.formKey,
    // required this.experimentRequestModel,
  }) : super(key: key);

  // final PageController pageController;
  final GlobalKey<FormState> formKey;
  // final ExperimentRequestModel experimentRequestModel;

  @override
  State<CreateExperimentThirdStepPage> createState() =>
      _CreateExperimentThirdStepPageState();
}

class _CreateExperimentThirdStepPageState
    extends State<CreateExperimentThirdStepPage> {
  late final CreateExperimentController controller;
  late GroupButtonController _checkboxesController;
  late final _checkboxButtons = [];
  final _choosedCheckboxList = <EnzymeModel>[];

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();

    Future.delayed(Duration.zero, () async {
      controller.loadEnzymes().whenComplete(
            () => controller.enzymes.forEach(
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

  //TODO: Integrar API para obter as enzimas

  Widget get _body {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppSvgs.iconLogo,
              alignment: Alignment.center,
              width: 75,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              "Cadastre um novo\nexperimento",
              style: TextStyles.titleHome,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              const Icon(
                PhosphorIcons.flask,
                color: AppColors.greyMedium,
              ),
              const SizedBox(width: 4),
              Text(
                'Enzimas',
                style: TextStyles.detailBold,
              ),
            ],
          ),
          Visibility(
            visible: controller.state == CreateExperimentState.loading,
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
                      _choosedCheckboxList.add(controller.enzymes[index]);
                      log(_choosedCheckboxList.toString());
                      setState(() {
                        enableNextButton = _choosedCheckboxList.isNotEmpty;
                      });

                      return;
                    }
                    _checkboxesController.unselectIndex(index);
                    _choosedCheckboxList.remove(controller.enzymes[index]);
                    setState(() {
                      enableNextButton = _choosedCheckboxList.isNotEmpty;
                    });

                    log(_choosedCheckboxList.toString());
                  },
                );
              },
              onSelected: (val, i, selected) =>
                  debugPrint('Button: $val index: $i $selected'),
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
          // const SizedBox(height: 40),
          // _checkBoxListTile,
          // const SizedBox(height: 64),
        ],
      ),
    );
  }

  // Widget get _checkBoxListTile {
  //   return Column(
  //     children: _enzymeSelection.map((enzyme) {
  //       return CheckboxListTile(
  //           dense: true,
  //           contentPadding: const EdgeInsets.all(0),
  //           value: enzyme["isChecked"],
  //           title: Text(enzyme["name"], style: TextStyles.titleBoldHeading),
  //           controlAffinity: ListTileControlAffinity.leading,
  //           onChanged: (newValue) {
  //             setState(() {
  //               enzyme["isChecked"] = newValue;
  //               for (int i = 0; i < _enzymeSelection.length; i++) {
  //                 if (_enzymeSelection[i]["isChecked"]) {
  //                   enableNextButton = true;
  //                   break;
  //                 } else if (i == _enzymeSelection.length - 1) {
  //                   enableNextButton = false;
  //                 }
  //               }
  //             });
  //           });
  //     }).toList(),
  //   );
  // }

  Widget get _buttons {
    var _choosedCheckboxListFormatted = [];
    _choosedCheckboxList.forEach((element) {
      _choosedCheckboxListFormatted.add(element.toMap());
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

            // widget.experimentDataCache.update(
            //   'experimentsEnzymes',
            //   (value) => json.encode(_choosedCheckboxListFormatted,
            //       toEncodable: Toolkit.encodeDateTime),
            // );
            // widget.experimentDataCache
            //     .update('enableNextButton3', (value) => 'true');

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
            controller.pageController.animateTo(
              MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CreateExperimentController>();

    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Center(child: _body),
        ),
        Expanded(
          flex: 4,
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
