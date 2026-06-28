// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../core/data/service/secure_storage/secure_session_storage.dart';
import '../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
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

  SplashViewmodel(
    this.experimentsViewmodel,
    this.enzymesViewmodel,
    this.treatmentsViewmodel,
    this.settingsViewmodel,
    this.userPreferencesServices,
    this.secureSessionStorage,
  ) {
    fetch();
  }

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

  List<EnzymeEntity>? _enzymes;
  List<EnzymeEntity>? get enzymes => _enzymes;
  void setEnzymes(List<EnzymeEntity>? state) {
    _enzymes = enzymes;
    notifyListeners();
  }

  Future<void> fetch() async {
    setStateEnum(StateEnum.loading);

    // Migração única do token legado do SharedPreferences para o armazenamento seguro.
    await secureSessionStorage.migrateFromLegacyIfNeeded(
      legacyReader: () => userPreferencesServices.getToken(),
      legacyClearer: (_) => userPreferencesServiceTokenCleanup(),
    );

    final hasToken = await secureSessionStorage.hasToken();

    try {
      if (hasToken) {
        await experimentsViewmodel.fetch();
        await enzymesViewmodel.fetch();
        await treatmentsViewmodel.fetch();
        await settingsViewmodel.fetch();

        if (experimentsViewmodel.state == StateEnum.error) {
          _setFailure(experimentsViewmodel.failure);
          setStateEnum(StateEnum.error);
        } else if (enzymesViewmodel.state == StateEnum.error) {
          _setFailure(enzymesViewmodel.failure);
          setStateEnum(StateEnum.error);
        } else if (treatmentsViewmodel.state == StateEnum.error) {
          _setFailure(treatmentsViewmodel.failure);
          setStateEnum(StateEnum.error);
        } else if (settingsViewmodel.state == StateEnum.error) {
          _setFailure(settingsViewmodel.failure);
          setStateEnum(StateEnum.error);
        }
      }
    } on Exception catch (e) {
      _setFailure(GenericFailure(message: e.toString()));
      setStateEnum(StateEnum.error);
    }

    setStateEnum(StateEnum.success);
  }

  Future<void> userPreferencesServiceTokenCleanup() async {
    await userPreferencesServices.removeToken();
  }
}
