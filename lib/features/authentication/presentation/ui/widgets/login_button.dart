// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import '../../../../../shared/l10n/app_localizations.dart';

// 🌎 Project imports:
import '../../../../../core/enums/enums.dart';
import '../../../../main/presentation/viewmodel/home_viewmodel.dart';
import '../../viewmodel/login_viewmodel.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final LoginViewmodel loginViewmodel;
  const LoginButton({super.key, required this.formKey, required this.loginViewmodel});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: loginViewmodel,
      builder: (context, child) {
        bool loading =
            loginViewmodel.state == StateEnum.loading || GetIt.I.get<HomeViewmodel>().state == StateEnum.loading;
        return SizedBox(
          width: double.maxFinite,
          height: 48,
          child: FilledButton(
            onPressed: loading
                ? null
                : () {
                    if (formKey.currentState!.validate()) {
                      loginViewmodel.loginAction();
                    }
                  },
            child: loading ? const CircularProgressIndicator() : Text(l10n.loginButton),
          ),
        );
      },
    );
  }
}
