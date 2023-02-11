// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../core/enums/enums.dart';
import '../../../../../shared/ui/ui.dart';
import '../../viewmodel/login_viewmodel.dart';

// 🌎 Project imports:

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const LoginButton({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewmodel = GetIt.I.get<LoginViewmodel>();

    return EZTButton(
      text: 'Entrar',
      eztButtonType: EZTButtonType.checkout,
      // loading: viewmodel.state == StateEnum.loading ||
      //     Provider.of<HomeViewmodel>(context, listen: false).state ==
      //         StateEnum.loading,
      onPressed: viewmodel.state == StateEnum.loading
          ? null
          : () {
              if (formKey.currentState!.validate()) {
                viewmodel.loginAction();
              }
            },
    );
  }
}
