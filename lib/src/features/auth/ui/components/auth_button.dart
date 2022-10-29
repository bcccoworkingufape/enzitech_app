// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_button.dart';

class AuthButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  const AuthButton({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<AuthViewmodel>();

    return EZTButton(
      text: 'Entrar',
      eztButtonType: EZTButtonType.checkout,
      loading: viewmodel.state == StateEnum.loading ||
          Provider.of<HomeViewmodel>(context, listen: false).state ==
              StateEnum.loading,
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
