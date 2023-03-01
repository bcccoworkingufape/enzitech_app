// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../core/enums/enums.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../main/presentation/viewmodel/home_viewmodel.dart';
import '../../viewmodel/login_viewmodel.dart';

// 🌎 Project imports:

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final LoginViewmodel loginViewmodel;
  const LoginButton(
      {Key? key, required this.formKey, required this.loginViewmodel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: loginViewmodel,
      builder: (context, child) {
        return EZTButton(
          text: 'Entrar',
          eztButtonType: EZTButtonType.checkout,
          loading: loginViewmodel.state == StateEnum.loading ||
              GetIt.I.get<HomeViewmodel>().state == StateEnum.loading,
          onPressed: loginViewmodel.state == StateEnum.loading
              ? null
              : () {
                  if (formKey.currentState!.validate()) {
                    loginViewmodel.loginAction();
                  }
                },
        );
      },
    );
  }
}
