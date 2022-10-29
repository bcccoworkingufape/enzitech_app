// 🐦 Flutter imports:

// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/ui/components/auth_button.dart';
import 'package:enzitech_app/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_textfield.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/utilities/validator/validator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  // late final AuthController controller;
  late final AuthViewmodel viewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController(text: '');
  final _passwordFieldController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<AuthViewmodel>();

    if (mounted) {
      viewmodel.addListener(() async {
        if (viewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(
              viewmodel.failure!,
              overrideDefaultMessage: true,
            ),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (viewmodel.state == StateEnum.success && mounted) {
          Provider.of<HomeViewmodel>(context, listen: false)
              .getContent()
              .then((value) {
            EZTSnackBar.show(
              context,
              "Bem vindo(a) ${viewmodel.loggedName}!",
              eztSnackBarType: EZTSnackBarType.success,
            );

            if (mounted) {
              Navigator.pushReplacementNamed(context, RouteGenerator.home);
            }
          });
        }
      });
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
      onChanged: (value) => viewmodel.setEmail(value),
      fieldValidator: fieldValidator,
      disableSuffixIcon: true,
    );
  }

  Widget get _passwordInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.required,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      eztTextFieldType: EZTTextFieldType.underline,
      labelText: "Senha",
      usePrimaryColorOnFocusedBorder: true,
      controller: _passwordFieldController,
      onChanged: (value) => viewmodel.setPassword(value),
      obscureText: true,
      fieldValidator: fieldValidator,
    );
  }

  Widget get _textFields {
    return Column(
      children: [
        _emailInput,
        const SizedBox(height: 10),
        _passwordInput,
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
                      AppSvgs.fullLogo,
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  const SizedBox(height: 64),
                  Text(
                    "Olá,\nseja bem vindo!",
                    style: TextStyles.titleHomeRegular,
                  ),
                  const SizedBox(height: 16),
                  _textFields,
                  // const SizedBox(height: 16),
                  // Align(
                  //   alignment: Alignment.centerRight,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.pushNamed(
                  //         context,
                  //         RouteGenerator.recoverPassword,
                  //       );
                  //     },
                  //     child: Text(
                  //       "Esqueci minha senha",
                  //       style: TextStyles.detailRegular.copyWith(
                  //         decoration: TextDecoration.underline,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 64),
                  AuthButton(formKey: _formKey),
                  const SizedBox(height: 32),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Não tem uma conta?',
                        style: TextStyles.detailRegular,
                        children: <TextSpan>[
                          TextSpan(
                            text: ' Crie uma',
                            style: TextStyles.link,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  RouteGenerator.createAccount,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
