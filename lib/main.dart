import 'core/data/service/user_preferences/user_preferences_service_imp.dart';
import 'features/main/presentation/ui/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

import 'core/data/service/key_value/key_value_service_imp.dart';
import 'core/domain/entities/http_driver_options.dart';
import 'core/inject/inject.dart';
import 'core/routing/routing.dart';
import 'features/main/presentation/viewmodel/splash_viewmodel.dart';
import 'shared/ui/ui.dart';
import 'shared/utils/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var keyValueService = SharedPrefsServiceImp();
  var userPreferencesService = UserPreferencesServicesImp(keyValueService);

  String token = await userPreferencesService.getToken() ?? '';

  final HttpDriverOptions httpDriverOptions = HttpDriverOptions(
    accessToken: () {
      return token;
    },
    baseUrl: () => API.BASE_URL,
    apiKey: 'ezt_bcc_coworking',
  );

  Inject.initialize(httpDriverOptions);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SplashViewmodel _splashViewmodel;

  @override
  void initState() {
    super.initState();
    _splashViewmodel = getIt.get<SplashViewmodel>();
    // _splashViewmodel.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.focusedChild?.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Enzitech',
        // theme: ThemeData.dark(),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: AppColors.white,
            ),
          ),
          primarySwatch: AppColors.materialTheme,
        ),
        initialRoute: Routing.initial,
        onGenerateRoute: Routing.generateRoute,
        home: /* Scaffold(
          body: Center(child: Text(DateTime.now().toString())),
        ) */
            const SplashPage(),
      ),
    );
  }
}
