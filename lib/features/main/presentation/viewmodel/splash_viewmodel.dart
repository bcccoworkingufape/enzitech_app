// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../core/data/service/secure_storage/secure_session_storage.dart';
import '../../../../core/domain/service/http/http_service.dart';
import '../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/routing/routing.dart';
import '../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import '../../../experiment/presentation/viewmodel/experiments_viewmodel.dart';
import '../../../treatment/presentation/viewmodel/treatments_viewmodel.dart';
import 'settings_viewmodel.dart';

class SplashViewmodel extends ChangeNotifier {
  final ExperimentsViewmodel experimentsViewmodel;
  final EnzymesViewmodel enzymesViewmodel;
  final TreatmentsViewmodel treatmentsViewmodel;
  final SettingsViewmodel settingsViewmodel;
  final UserPreferencesService userPreferencesServices;
  final SecureSessionStorage secureSessionStorage;
  final HttpService httpService;

  SplashViewmodel(
    this.experimentsViewmodel,
    this.enzymesViewmodel,
    this.treatmentsViewmodel,
    this.settingsViewmodel,
    this.userPreferencesServices,
    this.secureSessionStorage,
    this.httpService,
  );

  StateEnum _state = StateEnum.idle;
  StateEnum get state => _state;
  void setStateEnum(StateEnum state) {
    _state = state;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure => _failure;
  void _setFailure(Failure? failure) {
    _failure = failure;
  }

  String _destinationRoute = Routing.initial;
  String get destinationRoute => _destinationRoute;
  void setDestinationRoute(String destinationRoute) {
    _destinationRoute = destinationRoute;
    notifyListeners();
  }

  List<EnzymeEntity>? _enzymes;
  List<EnzymeEntity>? get enzymes => _enzymes;
  void setEnzymes(List<EnzymeEntity>? state) {
    _enzymes = enzymes;
    notifyListeners();
  }

  Future<String> resolveInitialRoute() async {
    try {
      await secureSessionStorage.migrateFromLegacyIfNeeded(
        legacyReader: () => userPreferencesServices.getToken(),
        legacyClearer: (_) => userPreferencesServiceTokenCleanup(),
      );

      final token = await secureSessionStorage.readToken() ?? '';
      if (token.isNotEmpty) {
        await httpService.setConfig(token: token);

        await experimentsViewmodel.fetch();
        await enzymesViewmodel.fetch();
        await treatmentsViewmodel.fetch();
        await settingsViewmodel.fetch();

        if (experimentsViewmodel.state == StateEnum.error) {
          _setFailure(experimentsViewmodel.failure);
          setStateEnum(StateEnum.error);
          return Routing.login;
        }
        if (enzymesViewmodel.state == StateEnum.error) {
          _setFailure(enzymesViewmodel.failure);
          setStateEnum(StateEnum.error);
          return Routing.login;
        }
        if (treatmentsViewmodel.state == StateEnum.error) {
          _setFailure(treatmentsViewmodel.failure);
          setStateEnum(StateEnum.error);
          return Routing.login;
        }
        if (settingsViewmodel.state == StateEnum.error) {
          _setFailure(settingsViewmodel.failure);
          setStateEnum(StateEnum.error);
          return Routing.login;
        }

        final authenticatedRoute = Routing.home;
        setDestinationRoute(authenticatedRoute);
        return authenticatedRoute;
      }
    } on Exception catch (e) {
      _setFailure(GenericFailure(message: e.toString()));
      setStateEnum(StateEnum.error);
      return Routing.login;
    }

    final unauthenticatedRoute = Routing.login;
    setDestinationRoute(unauthenticatedRoute);
    return unauthenticatedRoute;
  }

  Future<void> fetch() async {
    setStateEnum(StateEnum.loading);

    final nextRoute = await resolveInitialRoute();
    setDestinationRoute(nextRoute);

    if (state == StateEnum.error) {
      return;
    }

    setStateEnum(StateEnum.success);
  }

  Future<void> userPreferencesServiceTokenCleanup() async {
    await userPreferencesServices.removeToken();
  }
}
