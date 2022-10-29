// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/infra/implementations/providers/config_providers.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/providers/repo_providers.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/providers/viewmodel_providers.dart';
import 'package:enzitech_app/src/shared/external/http_driver/dio_client.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';

class AppWidget extends StatelessWidget {
  final HttpDriverOptions httpDriverOptions;

  const AppWidget({Key? key, required this.httpDriverOptions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...ConfigProviders.init(httpDriverOptions, context),
        ...RepoProviders.init(context),
        ...ViewmodelProviders.init(context),
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
          title: 'Enzitech',
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(
                color: AppColors.white,
              ),
            ),
            primarySwatch: AppColors.materialTheme,
          ),
          initialRoute: RouteGenerator.initial,
          onGenerateRoute: RouteGenerator.generateRoute,
          localizationsDelegates: const [
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FormBuilderLocalizations.delegate,
          ],
          supportedLocales: FormBuilderLocalizations.delegate.supportedLocales,
        ),
      ),
    );
  }
}
