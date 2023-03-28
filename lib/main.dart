// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// 🌎 Project imports:
import 'core/data/service/key_value/key_value_service_imp.dart';
import 'core/data/service/user_preferences/user_preferences_service_imp.dart';
import 'core/domain/entities/http_driver_options.dart';
import 'core/inject/inject.dart';
import 'core/routing/routing.dart';
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
    baseUrl: () => API.BASE_URL_WEVERTON,
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
  // late final SplashViewmodel _splashViewmodel;

  @override
  void initState() {
    super.initState();
    // _splashViewmodel = getIt.get<SplashViewmodel>();
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
        debugShowCheckedModeBanner: false,
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
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FormBuilderLocalizations.delegate,
        ],
        supportedLocales: const [
          ...FormBuilderLocalizations.supportedLocales,
        ],
      ),
    );
  }
}
