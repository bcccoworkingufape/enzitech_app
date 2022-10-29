// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/app_config.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/account/viewmodel/account_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final HomeViewmodel controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeViewmodel>();

    if (mounted) {
      controller.addListener(
        () async {
          if (controller.state == StateEnum.error && mounted) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
            var accountController = context.read<AccountViewmodel>();
            if (controller.failure is ExpiredTokenOrWrongUserFailure ||
                controller.failure is UserNotFoundOrWrongTokenFailure ||
                controller.failure is SessionNotFoundFailure) {
              accountController.logout();

              if (accountController.state == StateEnum.success && mounted) {
                EZTSnackBar.show(
                  context,
                  "Faça seu login novamente.",
                );
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) {
                  Navigator.pushReplacementNamed(context, RouteGenerator.auth);
                  controller.setFragmentIndex(0);
                }
              }
            }
          }
        },
      );
    }
    _checkAuth();
  }

  _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    Future.delayed(Duration.zero).then((_) async {
      String token = await getToken() ?? '';

      if (!mounted) return;

      if (token.isEmpty) {
        Navigator.pushReplacementNamed(context, RouteGenerator.auth);
      } else {
        await Provider.of<HomeViewmodel>(context, listen: false)
            .getContent()
            .then((value) =>
                Navigator.pushReplacementNamed(context, RouteGenerator.home));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SvgPicture.asset(
        AppSvgs.splash,
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    );
  }
}
