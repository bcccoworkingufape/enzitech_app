// import 'package:enzitech_app/features/home/data/datasources/get_enzymes_datasource.dart';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
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
  final SettingsViewmodel accountViewmodel;
  final UserPreferencesServices userPreferencesServices;

  SplashViewmodel(
    this.experimentsViewmodel,
    this.enzymesViewmodel,
    this.treatmentsViewmodel,
    this.accountViewmodel,
    this.userPreferencesServices,
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

    //TODO: check to fix backuped token: https://stackoverflow.com/a/35517411/10023840
    String token = await userPreferencesServices.getToken() ?? '';

    if (token.isNotEmpty) {
      await experimentsViewmodel.fetch();
      await enzymesViewmodel.fetch();
      await treatmentsViewmodel.fetch();
      await accountViewmodel.fetch();

      if (experimentsViewmodel.state == StateEnum.error) {
        _setFailure(experimentsViewmodel.failure);
        setStateEnum(StateEnum.error);
      } else if (enzymesViewmodel.state == StateEnum.error) {
        _setFailure(enzymesViewmodel.failure);
        setStateEnum(StateEnum.error);
      } else if (treatmentsViewmodel.state == StateEnum.error) {
        _setFailure(treatmentsViewmodel.failure);
        setStateEnum(StateEnum.error);
      } else if (accountViewmodel.state == StateEnum.error) {
        _setFailure(accountViewmodel.failure);
        setStateEnum(StateEnum.error);
      }
    }

    setStateEnum(StateEnum.success);
  }
}
