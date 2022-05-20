// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/auth_controller.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield_widget.dart';
import '../../shared/failures/failures.dart';
import 'components/auth_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  late final AuthController controller;
  final _userFieldController = TextEditingController(text: '');
  final _passwordFieldController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    controller = context.read<AuthController>();

    if (mounted) {
      controller.addListener(() {
        if (controller.state == AuthState.error) {
          if (controller.failure is ForbiddenFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(controller.failure!.message)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro na autenticação')));
          }
        } else if (controller.state == AuthState.success) {
          Navigator.of(context).pushReplacementNamed(RouteGenerator.home);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget get _textFields {
    return Column(
      children: [
        EZTTextFieldWidget(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Usuário",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _userFieldController,
          onChanged: (value) => print(value),
        ),
        const SizedBox(height: 10),
        EZTTextFieldWidget(
          eztTextFieldType: EZTTextFieldType.underline,
          labelText: "Senha",
          usePrimaryColorOnFocusedBorder: true,
          keyboardType: TextInputType.emailAddress,
          controller: _passwordFieldController,
          onChanged: (value) => print(value),
          obscureText: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Esqueci minha senha",
                    style: TextStyles.detailRegular.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 64),
                const AuthButton(),
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
                              print("Navegar para tela de criação de conta");
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
    );
  }
}
