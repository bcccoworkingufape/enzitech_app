// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';
import '../auth_controller.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return EZTButton(
      text: 'Entrar',
      eztButtonType: EZTButtonType.checkout,
      loading: controller.state == AuthState.loading,
      onPressed: controller.state == AuthState.loading
          ? null
          : () {
              controller.loginAction();
            },
    );
  }
}
