// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/infra/implementations/services/user_prefs_service.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';

class ConfigProviders {
  static List<SingleChildWidget> init(
    HttpDriverOptions httpDriverOptions,
    BuildContext context,
  ) {
    return [
      //* INIT DIO CLIENT
      Provider(
        create: (context) => DioClient(httpDriverOptions),
      ),
      //* INIT USER PREFS
      Provider(
        create: (context) => UserPrefsServices(),
      ),
    ];
  }
}
