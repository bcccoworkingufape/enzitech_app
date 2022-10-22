// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/app_config.dart';
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/utilities/failures/handle_failure.dart';
import 'package:enzitech_app/src/shared/utilities/failures/utils_failures.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();

    if (mounted) {
      controller.addListener(
        () async {
          if (controller.state == HomeState.error && mounted) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
            var accountController = context.read<AccountController>();
            if (controller.failure is ExpiredTokenOrWrongUserFailure ||
                controller.failure is UserNotFoundOrWrongTokenFailure ||
                controller.failure is SessionNotFoundFailure) {
              accountController.logout();

              if (accountController.state == AccountState.success && mounted) {
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
        await Provider.of<HomeController>(context, listen: false)
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
