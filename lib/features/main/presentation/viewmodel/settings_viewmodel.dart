// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import '../../../../core/enums/enums.dart';
import '../../../../core/failures/failures.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/utils/utils.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../domain/entities/app_info_entity.dart';
import '../../domain/usecases/user_preferences_usecases.dart';

class SettingsViewmodel extends ChangeNotifier {
  final UserPreferencesUseCases _userPreferencesUseCases;

  SettingsViewmodel(this._userPreferencesUseCases);

  bool _isReplaceLanguage = false;
  bool get isReplaceLanguage => _isReplaceLanguage;
  void setReplaceLanguage(bool isReplaceLanguage) {
    _isReplaceLanguage = isReplaceLanguage;
    _userPreferencesUseCases.saveReplaceLanguage(isReplaceLanguage);
    notifyListeners();
  }

  List<Locale> get locales => AppLocalizations.supportedLocales;

  Locale _locale = const Locale('en');
  Locale get locale => _locale;
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
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

  EnvironmentEnum get environment => API.enviroment;

  bool? _enableExcludeConfirmation;
  bool? get enableExcludeConfirmation => _enableExcludeConfirmation;
  void setEnableExcludeConfirmation(bool enableExcludeExperimentConfirmation) {
    _enableExcludeConfirmation = enableExcludeExperimentConfirmation;
    _userPreferencesUseCases.saveExcludeConfirmation(enableExcludeExperimentConfirmation);
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode newThemeMode) {
    _themeMode = newThemeMode;
    _userPreferencesUseCases.saveThemeMode(_themeMode);
    notifyListeners();
  }

  Future<void> updateThemeMode() async {
    setThemeMode(await _userPreferencesUseCases.getThemeMode());
  }

  String _savedPath = '';
  String get savedPath => _savedPath;
  void setSavedPath(String savedPath) {
    _savedPath = savedPath;
    notifyListeners();
  }

  Future<void> updateLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context);

    //* switch between locales
    switch (locale.languageCode) {
      case 'en':
        setLocale(const Locale('tr'));
        break;
      case 'tr':
        setLocale(const Locale('de'));
        break;
      case 'de':
        setLocale(const Locale('en'));
        break;
      default:
        setLocale(const Locale('en'));
        break;
    }
  }

  Future<void> logout() async {
    setStateEnum(StateEnum.loading);
    try {
      _userPreferencesUseCases.clearUser();

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
    setThemeMode(await _userPreferencesUseCases.getThemeMode());

    var resultConfirmation = await _userPreferencesUseCases.getExcludeConfirmation();
    resultConfirmation.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setEnableExcludeConfirmation(success);
        notifyListeners();
      },
    );

    var resultReplaceLanguage = await _userPreferencesUseCases.getReplaceLanguage();
    resultReplaceLanguage.fold(
      (error) {
        _setFailure(error);
        setStateEnum(StateEnum.error);
      },
      (success) async {
        setReplaceLanguage(success);
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

    var result = await _userPreferencesUseCases.getUser();

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

  Future<void> openUrl(String url) async {
    if (!await canLaunchUrl(Uri.parse(url))) {
      throw UnableToOpenUrlFailure(message: url);
    }
  }
}
