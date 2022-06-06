// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_account/create_account_controller.dart';
import 'package:enzitech_app/src/features/recover_password/recover_password_controller.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_colors.dart';
import 'features/auth/auth_controller.dart';

class AppWidget extends StatelessWidget {
  final HttpDriverOptions httpDriverOptions;

  const AppWidget({Key? key, required this.httpDriverOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) => DioClient(httpDriverOptions),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => CreateAccountController(context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => RecoverPasswordController(context.read()),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: AppColors.materialTheme,
          ),
          initialRoute: RouteGenerator.initial,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
