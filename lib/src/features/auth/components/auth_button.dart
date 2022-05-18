// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import '../auth_controller.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AuthController>();

    return ElevatedButton(
      onPressed: controller.state == AuthState.loading
          ? null
          : () {
              controller.loginAction();
            },
      child: const Text('Login'),
    );
  }
}
