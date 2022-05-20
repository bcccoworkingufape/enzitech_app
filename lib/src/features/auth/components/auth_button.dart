// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_text_styles.dart';
import '../auth_controller.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(vertical: 16)),
          ),
          onPressed: controller.state == AuthState.loading
              ? null
              : () {
                  controller.loginAction();
                },
          child: Text('Entrar', style: TextStyles.buttonPrimary),
        ),
      ],
    );
  }
}
