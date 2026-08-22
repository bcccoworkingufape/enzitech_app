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
import 'core/data/service/secure_storage/secure_session_storage.dart';
import 'core/data/service/user_preferences/user_preferences_service_imp.dart';
import 'core/domain/entities/http_driver_options.dart';
import 'core/inject/inject.dart';
import 'core/network/secure_network_config.dart';
import 'core/routing/routing.dart';
import 'features/main/presentation/viewmodel/settings_viewmodel.dart';
import 'firebase_options.dart';
import 'shared/l10n/app_localizations.dart';
import 'shared/ui/ui.dart';
import 'shared/utils/utils.dart';

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    var keyValueService = SharedPrefsServiceImp();
    var userPreferencesService = UserPreferencesServiceImp(keyValueService);
    var secureSessionStorage = SecureSessionStorage();

    // Migração única do token legado baseado em SharedPreferences para o armazenamento seguro. Idempotente: inicializações subsequentes não fazem nada.
    await secureSessionStorage.migrateFromLegacyIfNeeded(
      legacyReader: () => userPreferencesService.getToken(),
      legacyClearer: (_) => userPreferencesService.removeToken(),
    );

    String token = await secureSessionStorage.readToken() ?? '';

    final env = API.environmentFromDefine();
    API.setEnvironment(env);

    // A proteção de rede é executada após a seleção do ambiente e valida a
    // URL base (HTTPS obrigatório em release para produção, exceto na lista de exceções legada).
    final baseUrl = API.apiBaseUrl as String;
    SecureNetworkConfig.validateBaseUrl(baseUrl, env);
    SecureNetworkConfig.pinningFor(env);

    final HttpDriverOptions httpDriverOptions = HttpDriverOptions(
      accessToken: () {
        return token;
      },
      baseUrl: () => API.apiBaseUrl,
    );

    Inject.initialize(httpDriverOptions);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await GetIt.I.get<SettingsViewmodel>().updateThemeMode();

    runApp(const MyApp());
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SettingsViewmodel _settingsViewmodel;

  @override
  void initState() {
    super.initState();
    _settingsViewmodel = GetIt.I.get<SettingsViewmodel>();
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
      child: ListenableBuilder(
        listenable: _settingsViewmodel,
        builder: (context, child) {
          return MaterialApp(
            title: 'Enzitech',
            debugShowCheckedModeBanner: false,
            themeMode: _settingsViewmodel.themeMode,
            theme: ThemeData(useMaterial3: true, colorScheme: AppColors.lightColorScheme),
            darkTheme: ThemeData(useMaterial3: true, colorScheme: AppColors.darkColorScheme),
            initialRoute: Routing.initial,
            onGenerateRoute: Routing.generateRoute,
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              FormBuilderLocalizations.delegate,
            ],
            supportedLocales: [const Locale('pt'), const Locale('en')],
            locale: _settingsViewmodel.isReplaceLanguage ? _settingsViewmodel.locale : null,
          );
        },
      ),
    );
  }
}
