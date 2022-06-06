// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/app_widget.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpDriverOptions httpDriverOptions = HttpDriverOptions(
    accessToken: () {
      // var session = getCurrentSession();
      // return session != null ? session.token : "";
      return "";
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
