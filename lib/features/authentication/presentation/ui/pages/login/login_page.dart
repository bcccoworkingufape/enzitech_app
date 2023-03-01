// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/validator/validator.dart';
import '../../../../../main/presentation/viewmodel/home_viewmodel.dart';
import '../../../viewmodel/login_viewmodel.dart';
import '../../widgets/login_button.dart';

// 🌎 Project imports:

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // late final AuthController controller;
  late final LoginViewmodel _loginViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailFieldController = TextEditingController(text: '');
  final _passwordFieldController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _loginViewmodel = GetIt.I.get<LoginViewmodel>();

    if (mounted) {
      _loginViewmodel.addListener(() async {
        if (_loginViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(
              _loginViewmodel.failure!,
            ),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (_loginViewmodel.state == StateEnum.success && mounted) {
          GetIt.I.get<HomeViewmodel>().fetch().then((value) {
            if (GetIt.I.get<HomeViewmodel>().state == StateEnum.success &&
                mounted) {
              EZTSnackBar.show(
                context,
                "Bem vindo(a) ${_loginViewmodel.loggedName}!",
                eztSnackBarType: EZTSnackBarType.success,
              );
              Navigator.pushReplacementNamed(context, Routing.home);
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
      onChanged: (value) => _loginViewmodel.setEmail(value),
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
      onChanged: (value) => _loginViewmodel.setPassword(value),
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
                  LoginButton(
                    formKey: _formKey,
                    loginViewmodel: _loginViewmodel,
                  ),
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
                                  Routing.createAccount,
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
