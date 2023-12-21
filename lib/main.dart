// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import 'core/data/service/key_value/key_value_service_imp.dart';
import 'core/data/service/user_preferences/user_preferences_service_imp.dart';
import 'core/domain/entities/http_driver_options.dart';
import 'core/enums/enums.dart';
import 'core/inject/inject.dart';
import 'core/routing/routing.dart';
import 'features/main/presentation/viewmodel/settings_viewmodel.dart';
import 'firebase_options.dart';
import 'shared/ui/ui.dart';
import 'shared/utils/utils.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    var keyValueService = SharedPrefsServiceImp();
    var userPreferencesService = UserPreferencesServicesImp(keyValueService);

    String token = await userPreferencesService.getToken() ?? '';

    API.setEnvironment(EnvironmentEnum.prod);

    final HttpDriverOptions httpDriverOptions = HttpDriverOptions(
      accessToken: () {
        return token;
      },
      baseUrl: () => API.apiBaseUrl,
    );

    Inject.initialize(httpDriverOptions);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late final SplashViewmodel _splashViewmodel;
  late final SettingsViewmodel _settingsViewmodel;

  @override
  void initState() {
    super.initState();
    _settingsViewmodel = GetIt.I.get<SettingsViewmodel>();

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
      child: AnimatedBuilder(
        animation: _settingsViewmodel,
        builder: (context, child) {
          return MaterialApp(
            title: 'Enzitech',
            debugShowCheckedModeBanner: false,
            themeMode: _settingsViewmodel.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: AppColors.lightColorScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: AppColors.darkColorScheme,
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
          );
        },
      ),
    );
  }
}
