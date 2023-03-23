// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../shared/utils/utils.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/app_info_entity.dart';
import '../../domain/usecases/clear_user/clear_user_usecase.dart';
import '../../domain/usecases/get_exclude_confirmation/get_exclude_confirmation_usecase.dart';
import '../../domain/usecases/get_user/get_user_usecase.dart';
import '../../domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase.dart';

class AccountViewmodel extends ChangeNotifier {
  final GetUserUseCase _getUserUseCase;
  final GetExcludeConfirmationUseCase _getExcludeConfirmationUseCase;
  final SaveExcludeConfirmationUseCase _saveExcludeConfirmationUseCase;
  final ClearUserUseCase _clearUserUseCase;

  // final UserPreferencesServices _userPreferencesServices;

  AccountViewmodel(
    this._getUserUseCase,
    this._getExcludeConfirmationUseCase,
    this._saveExcludeConfirmationUseCase,
    this._clearUserUseCase,
    // this._userPreferencesServices,
  ) {
    // fetch();
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

  UserEntity? _user;
  UserEntity? get user => _user;
  void _setUser(UserEntity? user) {
    _user = user;
    notifyListeners();
  }

  AppInfoEntity? _appInfo;
  AppInfoEntity? get appInfo => _appInfo;
  void _setAppInfo(AppInfoEntity? appInfo) {
    _appInfo = appInfo;
    notifyListeners();
  }

  bool? _enableExcludeConfirmation;
  bool? get enableExcludeConfirmation => _enableExcludeConfirmation;
  void setEnableExcludeConfirmation(bool enableExcludeExperimentConfirmation) {
    _enableExcludeConfirmation = enableExcludeExperimentConfirmation;
    _saveExcludeConfirmationUseCase(enableExcludeExperimentConfirmation);
    notifyListeners();
  }

  logout() async {
    setStateEnum(StateEnum.loading);
    try {
      _clearUserUseCase();

      setStateEnum(StateEnum.success);

      _setUser(null);
      _setAppInfo(null);
    } catch (e) {
      _setFailure(e as Failure);
      setStateEnum(StateEnum.error);
    }
  }

  Future<void> fetch() async {
    setStateEnum(StateEnum.loading);

    await loadAccount();
    await loadPreferences();
    await loadAppInfo();

    setStateEnum(StateEnum.success);
  }

  Future<void> loadPreferences() async {
    // setStateEnum(StateEnum.loading);

    var result = await _getExcludeConfirmationUseCase();
    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setEnableExcludeConfirmation(success);
        notifyListeners();
      },
    );
  }

  Future<void> loadAppInfo() async {
    setStateEnum(StateEnum.loading);
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      AppInfoEntity appInfoModel = AppInfoEntity(
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

    var result = await _getUserUseCase();

    result.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        _setUser(success);
        setStateEnum(StateEnum.success);
      },
    );
  }

  Future<void> openUrl() async {
    try {
      if (!await launchUrl(Uri.parse(Constants.bccCoworkingLink))) {
        throw UnableToOpenUrlFailure(
            message:
                'Não foi possível acessar ${Uri.parse(Constants.bccCoworkingLink)}');
      }
    } on Exception catch (e) {
      _setFailure(e as Failure);
      // setStateEnum(StateEnum.error);
    }
  }
}
