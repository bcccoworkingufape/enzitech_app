// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';
import '../../../shared/util/util.dart';

class CreateAccountFirstStep extends StatefulWidget {
  const CreateAccountFirstStep({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  CreateAccountFirstStepState createState() => CreateAccountFirstStepState();
}

class CreateAccountFirstStepState extends State<CreateAccountFirstStep> {
  late final CreateAccountController controller;
  final _nameFieldController = TextEditingController(text: '');
  final _institutionFieldController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateAccountController>();
  }

  Widget get _textFields {
    return Column(
      children: [
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Nome",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _nameFieldController,
          onChanged: (value) => print(value),
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Instituição",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _institutionFieldController,
          onChanged: (value) => print(value),
          obscureText: true,
        ),
      ],
    );
  }

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
              "Cadastre-se",
              style: TextStyles.titleHome,
            ),
          ),
          const SizedBox(height: 64),
          Row(
            children: [
              const Icon(
                PhosphorIcons.identificationCardBold,
                color: AppColors.greyLight,
              ),
              const SizedBox(width: 4),
              Text(
                'Dados pessoais',
                style: TextStyles.detailBold,
              ),
            ],
          ),
          _textFields,
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          text: 'Próximo',
          onPressed: () {
            widget.pageController.animateTo(
              MediaQuery.of(context).size.width,
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
