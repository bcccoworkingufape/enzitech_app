// 🐦 Flutter imports:

// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:settings_ui/settings_ui.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../experiment/presentation/viewmodel/experiment_results_viewmodel.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../../../viewmodel/settings_viewmodel.dart';
import 'fragments/about_app_bs.dart';
import 'fragments/faq_bs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final SettingsViewmodel _settingsViewmodel;
  late final HomeViewmodel _homeViewmodel;

  @override
  void initState() {
    super.initState();

    _settingsViewmodel = GetIt.I.get<SettingsViewmodel>();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();
    _settingsViewmodel.fetchQuantityOfFiles();

    if (mounted) {
      _settingsViewmodel.addListener(() async {
        if (_settingsViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(_settingsViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        }

        if (_settingsViewmodel.state == StateEnum.success &&
            _settingsViewmodel.user == null &&
            mounted) {
          EZTSnackBar.clear(context);
          EZTSnackBar.show(context, "Até logo...");
          await Future.delayed(const Duration(milliseconds: 250));
          if (mounted) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, Routing.login);
              _homeViewmodel.setFragmentIndex(0);
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthMQ = MediaQuery.of(context).size.width;
    var heightMQ = MediaQuery.of(context).size.height;
    var descriptionTextStyle = const TextStyle(
      color: Color(0xFF97979A),
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );

    final scaleFactor = MediaQuery.of(context).textScaler;

    return ListenableBuilder(
        listenable: _settingsViewmodel,
        builder: (context, child) {
          return Scaffold(
            backgroundColor:
                Colors.white, // AppColors.background, //TODO: COLOR-FIX
            body: Builder(builder: (context) {
              if (_settingsViewmodel.user == null &&
                  _settingsViewmodel.state != StateEnum.error) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: heightMQ,
                width: widthMQ,
                child: Column(
                  children: [
                    Expanded(
                      child: SettingsList(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        lightTheme: const SettingsThemeData(
                            // settingsListBackground: Colors
                            //     .white, //AppColors.background, //TODO: COLOR-FIX
                            // titleTextColor: Colors
                            //     .blue, //AppColors.grenDark, //TODO: COLOR-FIX
                            // leadingIconsColor: Colors
                            //     .green, //AppColors.greyBlack, //TODO: COLOR-FIX
                            ),
                        sections: [
                          SettingsSection(
                            title: const Text('Informações'),
                            tiles: [
                              SettingsTile.navigation(
                                leading: Icon(
                                  PhosphorIcons.info(),
                                ),
                                title: const Text('Sobre o App'),
                                onPressed: (_) => showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    child: const AboutAppBS(),
                                  ),
                                ),
                              ),
                              SettingsTile.navigation(
                                leading: Icon(
                                  PhosphorIcons.question(),
                                ),
                                title: const Text('Perguntas frequentes'),
                                onPressed: (_) => showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    child: const FAQBS(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // ACCOUNT
                          SettingsSection(
                            title: const Text('Dados do usuário'),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.user(),
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Flex(
                                            direction: Axis.horizontal,
                                            children: [Text('Nome')],
                                          )
                                        : const Text('Nome'),
                                value:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flexible(
                                            flex: 4,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                _settingsViewmodel.user!.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _settingsViewmodel.user!.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.at(),
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Flex(
                                            direction: Axis.horizontal,
                                            children: [Text('Email')],
                                          )
                                        : const Text('Email'),
                                value:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flexible(
                                            flex: 4,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                _settingsViewmodel.user!.email,
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _settingsViewmodel.user!.email,
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.identificationBadge(),
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text('Tipo de usuário'),
                                            ],
                                          )
                                        : const Text('Tipo de usuário'),
                                value: defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? Flexible(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            _settingsViewmodel.user!.userType ==
                                                    UserTypeEnum.admin
                                                ? 'Administrador'
                                                : 'Comum',
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _settingsViewmodel.user!.userType ==
                                                UserTypeEnum.admin
                                            ? 'Administrador'
                                            : 'Comum',
                                        overflow: TextOverflow.ellipsis,
                                        style: descriptionTextStyle,
                                      ),
                              ),
                            ],
                          ),
                          // PREFERENCES
                          SettingsSection(
                            title: const Text('Configurações'),
                            tiles: [
                              SettingsTile.switchTile(
                                initialValue: _settingsViewmodel
                                    .enableExcludeConfirmation,
                                onToggle: (value) => _settingsViewmodel
                                    .setEnableExcludeConfirmation(value),
                                leading: Icon(
                                  PhosphorIcons.trash(),
                                ),
                                title: const Text('Confirmação de exclusão'),
                              ),
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.paintRoller(),
                                ),
                                title: const Text(''),
                                description: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(
                                        flex: 1, child: Text('Tema')),
                                    Flexible(
                                      flex: 4,
                                      child: SegmentedButton<ThemeMode>(
                                        showSelectedIcon: false,
                                        segments: <ButtonSegment<ThemeMode>>[
                                          ButtonSegment<ThemeMode>(
                                              value: ThemeMode.system,
                                              label: const Text('Sistema'),
                                              icon: Icon(Platform.isIOS
                                                  ? PhosphorIcons.appleLogo()
                                                  : PhosphorIcons
                                                      .androidLogo())),
                                          ButtonSegment<ThemeMode>(
                                              value: ThemeMode.light,
                                              label: const Text('Claro'),
                                              icon: Icon(PhosphorIcons.sun())),
                                          ButtonSegment<ThemeMode>(
                                              value: ThemeMode.dark,
                                              label: const Text('Escuro'),
                                              icon: Icon(PhosphorIcons.moon())),
                                        ],
                                        selected: <ThemeMode>{
                                          _settingsViewmodel.themeMode
                                        },
                                        onSelectionChanged:
                                            (Set<ThemeMode> newSelection) {
                                          _settingsViewmodel
                                              .setThemeMode(newSelection.first);
                                          setState(() {
                                            // By default there is only a single segment that can be
                                            // selected at one time, so its value is always the first
                                            // item in the selected set.
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // APP
                          SettingsSection(
                            title: const Text('App'),
                            tiles: [
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.files(),
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text(_settingsViewmodel
                                                  .dealWithDownloadedFiles),
                                            ],
                                          )
                                        : Text(_settingsViewmodel
                                            .dealWithDownloadedFiles),
                                value:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flexible(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                GetIt.I
                                                        .get<
                                                            ExperimentResultsViewmodel>()
                                                        .savedPath
                                                        .isNotEmpty
                                                    ? 'Localizado em: ${GetIt.I.get<ExperimentResultsViewmodel>().savedPath}'
                                                    : 'Salve o primeiro resultado para ver o local',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            GetIt.I
                                                    .get<
                                                        ExperimentResultsViewmodel>()
                                                    .savedPath
                                                    .isNotEmpty
                                                ? 'Localizado em: ${GetIt.I.get<ExperimentResultsViewmodel>().savedPath}'
                                                : 'Salve o primeiro resultado para ver o local',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.computerTower(),
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text('Ambiente'),
                                            ],
                                          )
                                        : const Text('Ambiente'),
                                value: defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? Flexible(
                                        flex: 1,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            _settingsViewmodel.getEnviroment,
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _settingsViewmodel.getEnviroment,
                                        overflow: TextOverflow.ellipsis,
                                        style: descriptionTextStyle,
                                      ),
                              ),
                              SettingsTile(
                                leading: Icon(
                                  PhosphorIcons.gitBranch(),
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? const Flex(
                                            direction: Axis.horizontal,
                                            children: [
                                              Text('Versão'),
                                            ],
                                          )
                                        : const Text('Versão'),
                                value:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flexible(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "${_settingsViewmodel.appInfo!.version}+${_settingsViewmodel.appInfo!.buildNumber}",
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "${_settingsViewmodel.appInfo!.version}+${_settingsViewmodel.appInfo!.buildNumber}",
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile.navigation(
                                leading: Icon(
                                  PhosphorIcons.signOut(),
                                  // color: AppColors.danger, //TODO: COLOR-FIX
                                ),
                                trailing:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Icon(
                                            CupertinoIcons.chevron_forward,
                                            size: scaleFactor.scale(
                                                18), // TODO: Verify this fix (was a multiplication when textScale wasnt deprecated)
                                            // color: AppColors.danger, //TODO: COLOR-FIX
                                          )
                                        : null,
                                title: const Text(
                                  'Sair',
                                  style: TextStyle(
                                      // color: AppColors.danger, //TODO: COLOR-FIX
                                      ),
                                ),
                                onPressed: (_) {
                                  _homeViewmodel.experimentsViewmodel
                                      .clearFilters();
                                  _settingsViewmodel.logout();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _settingsViewmodel.openUrl,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SvgPicture.asset(
                            AppSvgs.developedBy,
                            alignment: Alignment.bottomCenter,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        });
  }
}
