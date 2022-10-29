// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/user_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/business/domain/interfaces/providers/disposable_provider_interface.dart';
import 'package:enzitech_app/src/shared/business/infra/models/app_info_model.dart';
import 'package:enzitech_app/src/shared/business/infra/models/user_model.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/services/user_prefs_service.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class AccountViewmodel extends IDisposableProvider {
  final UserPrefsServices userPrefsServices;

  AccountViewmodel({
    required this.userPrefsServices,
  });

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

  UserEntity? _user;
  UserEntity? get user => _user;
  void _setUser(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  AppInfoModel? _appInfo;
  AppInfoModel? get appInfo => _appInfo;
  void _setAppInfo(AppInfoModel? appInfo) {
    _appInfo = appInfo;
    notifyListeners();
  }

  bool? _enableExcludeConfirmation;
  bool? get enableExcludeConfirmation => _enableExcludeConfirmation;
  void setEnableExcludeConfirmation(bool enableExcludeExperimentConfirmation) {
    _enableExcludeConfirmation = enableExcludeExperimentConfirmation;
    userPrefsServices
        .saveExcludeConfirmation(enableExcludeExperimentConfirmation);
    notifyListeners();
  }

  Future<void> logout() async {
    setStateEnum(StateEnum.loading);
    try {
      UserPrefsServices userPrefsServices = UserPrefsServices();
      userPrefsServices.clearAll();

      setStateEnum(StateEnum.success);

      _setUser(null);
      _setAppInfo(null);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> loadAccountFragment() async {
    setStateEnum(StateEnum.loading);

    await loadAccount();
    await loadPreferences();
    await loadAppInfo();

    setStateEnum(StateEnum.success);
  }

  Future<void> loadPreferences() async {
    bool enable = await userPrefsServices.getExcludeConfirmation();
    setEnableExcludeConfirmation(enable);
    notifyListeners();
  }

  Future<void> loadAppInfo() async {
    setStateEnum(StateEnum.loading);
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      //! TODO: mudar pra entity
      AppInfoModel appInfoModel = AppInfoModel(
        appName: packageInfo.appName,
        buildNumber: packageInfo.buildNumber,
        packageName: packageInfo.packageName,
        version: packageInfo.version,
      );

      _setAppInfo(appInfoModel);

      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> loadAccount() async {
    setStateEnum(StateEnum.loading);
    try {
      String? user = await userPrefsServices.getFullUser();

      _setUser(
        UserModel.fromJson(
          jsonDecode(user!),
        ).toEntity(),
      );

      setStateEnum(StateEnum.success);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> openUrl() async {
    try {
      if (!await launchUrl(Uri.parse(Constants.bccCoworkingLink))) {
        throw UnableToOpenURL(
            message:
                'Não foi possível acessar ${Uri.parse(Constants.bccCoworkingLink)}');
      }
    } on Exception catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  @override
  void disposeValues() {
    setStateEnum(StateEnum.idle);
    _setFailure(null);
    //? TODO: test clear _setEnzymes
  }
}
