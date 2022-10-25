// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/recover_password/viewmodel/recover_password_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_textfield.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/utilities/validator/validator.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  RecoverPasswordPageState createState() => RecoverPasswordPageState();
}

class RecoverPasswordPageState extends State<RecoverPasswordPage> {
  late final RecoverPasswordViewmodel viewmodel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController(text: '');
  var buttonEnabled = false;
  var enableTextField = true;

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<RecoverPasswordViewmodel>();

    if (_formKey.currentState != null) {
      buttonEnabled = _formKey.currentState!.validate();
    }

    if (mounted) {
      viewmodel.addListener(
        () async {
          if (viewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(viewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          } else if (viewmodel.state == StateEnum.success) {
            EZTSnackBar.show(
              context,
              "Solicitação de alteração de senha enviada com sucesso! Confira seu email.",
              eztSnackBarType: EZTSnackBarType.success,
            );

            Navigator.pushNamedAndRemoveUntil(
              context,
              RouteGenerator.auth,
              (Route<dynamic> route) => false,
            );
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
        viewmodel.setEmail(value);
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
            viewmodel.recoverPassword().whenComplete(() async {
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
