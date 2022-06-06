// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';

class CreateAccountSecondStep extends StatefulWidget {
  const CreateAccountSecondStep({
    Key? key,
    required this.pageController,
  }) : super(key: key);

  final PageController pageController;

  @override
  CreateAccountSecondStepState createState() => CreateAccountSecondStepState();
}

class CreateAccountSecondStepState extends State<CreateAccountSecondStep> {
  late final CreateAccountController controller;
  final _emailFieldController = TextEditingController(text: '');
  final _passwordFieldController = TextEditingController(text: '');
  final _confirmPasswordFieldController = TextEditingController(text: '');

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
          labelText: "Email",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _emailFieldController,
          onChanged: (value) => print(value),
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Senha",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _passwordFieldController,
          onChanged: (value) => print(value),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        EZTTextField(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Confirmar senha",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _confirmPasswordFieldController,
          onChanged: (value) => print(value),
          obscureText: true,
        ),
      ],
    );
  }

  Widget get _body {
    return SingleChildScrollView(
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
                PhosphorIcons.atBold,
                color: AppColors.greyLight,
              ),
              const SizedBox(width: 4),
              Text(
                'Acesso',
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
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        EZTButton(
          text: 'Criar conta',
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteGenerator.home,
              (route) => false,
            );
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Voltar',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            widget.pageController.animateTo(
              0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 11,
          child: Padding(
            padding: Constants.padding16all,
            child: Center(child: _body),
          ),
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
