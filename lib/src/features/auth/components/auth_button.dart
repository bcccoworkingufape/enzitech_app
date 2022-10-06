// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/auth_controller.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_button.dart';

class AuthButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const AuthButton({Key? key, required this.formKey}) : super(key: key);

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
              if (formKey.currentState!.validate()) {
                controller.loginAction();
              }
            },
    );
  }
}
