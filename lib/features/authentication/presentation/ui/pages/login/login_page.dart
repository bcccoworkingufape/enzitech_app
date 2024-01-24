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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
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
              isLogin: true,
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
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: true,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AppSvgs(context).fullLogo(),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3.33,
                          ),
                        ),
                        Text(
                          "Olá,\nseja bem vindo(a)!",
                          style: TextStyles.titleHomeRegular,
                        ),
                        _textFields,
                        Visibility(
                          visible:
                              false, // TODO: Implementar e remover Visibility
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    Routing.recoverPassword,
                                  );
                                },
                                child: Text(
                                  "Esqueci minha senha",
                                  style: TextStyles(context).captionBody(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.75,
                            child: LoginButton(
                              formKey: _formKey,
                              loginViewmodel: _loginViewmodel,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Não possui uma conta?',
                              style: TextStyles(context).detailRegular,
                              children: <TextSpan>[
                                TextSpan(
                                  text: ' Crie uma',
                                  style: TextStyles(context).link(),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
