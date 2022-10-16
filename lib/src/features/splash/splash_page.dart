// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/app_config.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

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
        Navigator.pushReplacementNamed(context, RouteGenerator.home);
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
