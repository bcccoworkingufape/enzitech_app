// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    PhosphorIcons.at,
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
              EZTButton(
                text: 'Próximo',
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
