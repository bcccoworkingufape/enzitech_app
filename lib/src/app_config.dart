// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/app_widget.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/services/user_prefs_service.dart';

Future<String?> getToken() async {
  UserPrefsServices userPrefsServices = UserPrefsServices();
  return await userPrefsServices.getToken();
}

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  String token = await getToken() ?? '';

  final HttpDriverOptions httpDriverOptions = HttpDriverOptions(
    accessToken: () {
      return token;
    },
    baseUrl: () =>
        "http://ec2-18-218-79-222.us-east-2.compute.amazonaws.com:3333",
    apiKey: 'ezt_bcc_coworking',
  );

  runApp(
    AppWidget(
      httpDriverOptions: httpDriverOptions,
    ),
  );
}

class AppConfig {}
