
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../shared/themes/app_complete_theme.dart';
import '../../../shared/util/constants.dart';
import '../../../shared/widgets/ezt_button.dart';

class CreateExperimentThirdStepPage extends StatefulWidget {
  const CreateExperimentThirdStepPage({
    Key? key,
    required this.pageController,
    required this.formKey,
    required this.experimentDataCache,
  }) : super(key: key);

  final PageController pageController;
  final GlobalKey<FormState> formKey;
  final Map<String, String> experimentDataCache;

  @override
  State<CreateExperimentThirdStepPage> createState() => _CreateExperimentThirdStepPageState();
}

class _CreateExperimentThirdStepPageState extends State<CreateExperimentThirdStepPage> {

  bool enableNextButton = false;

  List<Map> _enzymeSelection = [
    {"name": "Enzima 1", "isChecked": false},
    {"name": "Enzima 2", "isChecked": false},
    {"name": "Enzima 3", "isChecked": false},
    {"name": "Enzima 4", "isChecked": false},
  ];

  Widget get _body {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        children: [
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
          const SizedBox(height: 40),
          _checkBoxListTile,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget get _checkBoxListTile {
    return Column(
      children:
      _enzymeSelection.map((enzyme) {
        return CheckboxListTile(
          value: enzyme["isChecked"],
          title: Text(enzyme["name"], style: TextStyles.titleBoldHeading),
          controlAffinity: ListTileControlAffinity.leading,
          onChanged: (newValue) {
            setState(() {
              enzyme["isChecked"] = newValue;
              for(int i=0; i<_enzymeSelection.length; i++){
                if(_enzymeSelection[i]["isChecked"]){
                  enableNextButton = true;
                  break;
                }else if (i == _enzymeSelection.length-1){
                  enableNextButton = false;
                }
              }
            });
          });
      }).toList(),

    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: enableNextButton,
          text: 'Próximo',
          onPressed: () {
            widget.formKey.currentState!.save();

            widget.experimentDataCache
                .update('enzymeSelection', (value) => _enzymeSelection.toString());
            widget.experimentDataCache.update('enableNext', (value) => 'true');

            widget.pageController.nextPage(
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
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
