// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/auth_controller.dart';
import 'package:enzitech_app/src/features/recover_password/recover_password_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/validator/validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  RecoverPasswordPageState createState() => RecoverPasswordPageState();
}

class RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late final RecoverPasswordController controller;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController(text: '');
  var buttonEnabled = false;
  var enableTextField = true;

  @override
  void initState() {
    super.initState();
    controller = context.read<RecoverPasswordController>();

    if (_formKey.currentState != null) {
      buttonEnabled = _formKey.currentState!.validate();
    }

    if (mounted) {
      controller.addListener(
        () {
          if (controller.state == RecoverPasswordState.error) {
            EZTSnackBar.show(context, HandleFailure.of(controller.failure!));
          } else if (controller.state == AuthState.success) {
            Navigator.pushReplacementNamed(context, RouteGenerator.home);
          }
        },
      );
    }
  }

  Widget get _emailInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
      ValidateRule(
        ValidateTypes.email,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "E-mail",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.emailAddress,
      controller: _emailFieldController,
      enabled: enableTextField,
      onChanged: (value) async {
        controller.setEmail(value);
        buttonEnabled = _formKey.currentState!.validate();

        await Future.delayed(const Duration(milliseconds: 10));
        setState(() {});
      },
      fieldValidator: fieldValidator,
    );
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          text: 'Solicitar alteração',
          onPressed: () {
            controller.recoverPassword().whenComplete(() async {
              setState(
                () {
                  buttonEnabled = false;
                  enableTextField = false;
                },
              );
              setState(
                () {
                  _emailFieldController.text = 'Enviado, confira seu e-mail';
                },
              );
            });
          },
          enabled: buttonEnabled,
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
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
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
                      "Recuperar senha",
                      style: TextStyles.titleHome
                          .copyWith(color: AppColors.greyDark),
                    ),
                  ),
                  const SizedBox(height: 64),
                  Text(
                    "Se você já possui cadastro em nosso app e esqueceu sua senha, digite abaixo seu email para receber sua chave de acesso para a alteração da senha.",
                    style: TextStyles.informationRegular,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  _emailInput,
                  const SizedBox(height: 64),
                  // AuthButton(formKey: _formKey),
                  const SizedBox(height: 32),
                  _buttons,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
