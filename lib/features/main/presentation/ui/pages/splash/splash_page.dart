// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../viewmodel/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashViewmodel _splashViewmodel;

  @override
  void initState() {
    super.initState();
    _splashViewmodel = GetIt.I.get<SplashViewmodel>();

    if (mounted) {
      _splashViewmodel.addListener(
        () async {
          if (_splashViewmodel.state == StateEnum.error && mounted) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              HandleFailure.of(_splashViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
            // var accountController = context.read<AccountViewmodel>();
            // if (_splashViewmodel.failure is ExpiredTokenOrWrongUserFailure ||
            //     _splashViewmodel.failure is UserNotFoundOrWrongTokenFailure ||
            //     _splashViewmodel.failure is SessionNotFoundFailure) {
            //   accountController.logout();

            //   if (accountController.state == StateEnum.success && mounted) {
            //     EZTSnackBar.show(
            //       context,
            //       "Faça seu login novamente.",
            //     );
            //     await Future.delayed(const Duration(milliseconds: 500));
            //     if (mounted) {
            //       Navigator.pushReplacementNamed(context, RouteGenerator.auth);
            //       _splashViewmodel.setFragmentIndex(0);
            //     }
            //   }
            // }
          }
        },
      );
    }
    _checkAuth();
  }

  _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1));
    Future.delayed(Duration.zero).then((_) async {
      String token =
          await GetIt.I.get<UserPreferencesServices>().getToken() ?? '';

      if (!mounted) return;

      if (token.isEmpty) {
        Navigator.pushReplacementNamed(context, Routing.login);
      } else {
        // GetIt.I.get<KeyValueService>().clear();

        print('VAI PRA HOME');
        /* await Provider.of<HomeViewmodel>(context, listen: false)
            .getContent()
            .then((value) =>
                Navigator.pushReplacementNamed(context, Routing.home)); */
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
