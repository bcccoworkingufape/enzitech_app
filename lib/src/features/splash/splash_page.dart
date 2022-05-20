// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_colors.dart';

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
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    Future.delayed(Duration.zero).then((_) {
      Navigator.pushReplacementNamed(context, RouteGenerator.auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SvgPicture.asset(
        'assets/images/splash.svg',
        fit: BoxFit.contain,
        alignment: Alignment.center,
      ),
    );
  }
}
