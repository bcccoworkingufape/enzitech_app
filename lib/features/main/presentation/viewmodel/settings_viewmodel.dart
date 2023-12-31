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
import '../../domain/usecases/get_theme_mode/get_theme_mode_usecase.dart';
import '../../domain/usecases/get_user/get_user_usecase.dart';
import '../../domain/usecases/save_exclude_confirmation/save_exclude_confirmation_usecase.dart';
import '../../domain/usecases/save_theme_mode/save_theme_mode_usecase.dart';

class SettingsViewmodel extends ChangeNotifier {
  final GetUserUseCase _getUserUseCase;
  final GetExcludeConfirmationUseCase _getExcludeConfirmationUseCase;
  final SaveExcludeConfirmationUseCase _saveExcludeConfirmationUseCase;
  final GetThemeModeUseCase _getThemeModeUseCase;
  final SaveThemeModeUseCase _saveThemeModeUseCase;
  final ClearUserUseCase _clearUserUseCase;

  // final UserPreferencesServices _userPreferencesServices;

  SettingsViewmodel(
    this._getUserUseCase,
    this._getExcludeConfirmationUseCase,
    this._saveExcludeConfirmationUseCase,
    this._getThemeModeUseCase,
    this._saveThemeModeUseCase,
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

  get getEnviroment {
    switch (API.enviroment) {
      case EnvironmentEnum.dev:
        return 'Desenvolvimento';
      case EnvironmentEnum.stage:
        return 'Teste';
      case EnvironmentEnum.prod:
        return 'Produção';
    }
  }

  /*
  int _quantityFiles = 0;
  int get quantityFiles => _quantityFiles;
  void _setQuantityFiles(int quantityFiles) {
    _quantityFiles = quantityFiles;
    notifyListeners();
  }

  void fetchQuantityOfFiles() async {
    var files = io.Directory("${await getDownloadEnzitechPath()}")
        .listSync(); //use your folder name insted of resume.
    _setQuantityFiles(files.length);
  }

  get dealWithDownloadedFiles {
    if (quantityFiles == 0) {
      return 'Você não tem planilhas baixadas';
    } else if (quantityFiles == 1) {
      return 'Você tem 1 planilha baixada';
    } else {
      return 'Você tem $quantityFiles planilhas baixadas';
    }
  }
 */

  bool? _enableExcludeConfirmation;
  bool? get enableExcludeConfirmation => _enableExcludeConfirmation;
  void setEnableExcludeConfirmation(bool enableExcludeExperimentConfirmation) {
    _enableExcludeConfirmation = enableExcludeExperimentConfirmation;
    _saveExcludeConfirmationUseCase(enableExcludeExperimentConfirmation);
    notifyListeners();
  }

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode newThemeMode) {
    _themeMode = newThemeMode;
    _saveThemeModeUseCase(_themeMode);
    notifyListeners();
  }

  Future<void> updateThemeMode() async {
    setThemeMode(await _getThemeModeUseCase());
  }

  String _savedPath = '';
  String get savedPath => _savedPath;
  void setSavedPath(String savedPath) {
    _savedPath = savedPath;
    notifyListeners();
  }

  /* Future<String?> getDownloadEnzitechPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }

        directory = Directory('${directory!.path}/Enzitech');

        if (!await directory.exists()) {
          Directory(directory.path)
              .create()
              // The created directory is returned as a Future.
              .then((Directory directory) {
            // print('${directory.path} CRIADO!');
          });
        }
      }
    } catch (err, stack) {
      // print("Cannot get download folder path");
    }

    setSavedPath(directory?.path ?? 'seus arquivos');

    return directory?.path;
  }

  Future<void> openEnzitechFolder() async {
    openFileManager();
  } */

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

    setThemeMode(await _getThemeModeUseCase());

    var resultConfirmation = await _getExcludeConfirmationUseCase();
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

    // var resultTheme = await _getExcludeConfirmationUseCase();
    // resultTheme.fold(
    //   (error) {
    //     _setFailure(error);
    //     setStateEnum(StateEnum.error);
    //   },
    //   (success) async {
    //     setEnableExcludeConfirmation(success);
    //     notifyListeners();
    //   },
    // );
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
