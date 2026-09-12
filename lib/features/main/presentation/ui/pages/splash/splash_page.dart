// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/data/service/secure_storage/secure_session_storage.dart';
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../../../viewmodel/settings_viewmodel.dart';
import '../../../viewmodel/splash_viewmodel.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final SplashViewmodel _splashViewmodel;

  @override
  void initState() {
    super.initState();
    _splashViewmodel = GetIt.I.get<SplashViewmodel>();

    _splashViewmodel.addListener(_handleSplashState);
    _splashViewmodel.fetch();
  }

  void _handleSplashState() {
    if (!mounted) return;

    if (_splashViewmodel.state == StateEnum.error) {
      EZTSnackBar.clear(context);
      EZTSnackBar.show(
        context,
        HandleFailure.of(context.l10n, _splashViewmodel.failure!),
        eztSnackBarType: EZTSnackBarType.error,
      );

      final accountViewmodel = GetIt.I.get<SettingsViewmodel>();
      if (_splashViewmodel.failure is ExpiredTokenOrWrongUserFailure ||
          _splashViewmodel.failure is UserNotFoundOrWrongTokenFailure ||
          _splashViewmodel.failure is SessionNotFoundFailure) {
        accountViewmodel.logout().then((_) {
          if (!mounted) return;
          if (accountViewmodel.state == StateEnum.success) {
            EZTSnackBar.show(context, context.l10n.loginAgain);
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) {
                Navigator.pushReplacementNamed(context, Routing.login);
                GetIt.I.get<HomeViewmodel>().setFragmentIndex(0);
              }
            });
          }
        });
      }

      return;
    }

    if (_splashViewmodel.state == StateEnum.success && mounted) {
      final route = _splashViewmodel.destinationRoute;
      if (route != Routing.initial) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, route);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.getApplyedColorScheme.primary,
      body: SvgPicture.asset(AppSvgs(context).splash()),
    );
  }
}
