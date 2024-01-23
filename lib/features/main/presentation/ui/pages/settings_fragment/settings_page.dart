// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../../../viewmodel/settings_viewmodel.dart';
import '../../widgets/settings_section.dart';
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
    // _settingsViewmodel.fetchQuantityOfFiles();

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

  get descriptionTextStyle => const TextStyle(
        color: Color(0xFF97979A),
        fontSize: 17,
        fontWeight: FontWeight.w400,
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settingsViewmodel,
      builder: (context, child) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (_settingsViewmodel.user == null &&
                  _settingsViewmodel.state != StateEnum.error) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: [
                  SettingsSection(
                    title: 'Informações',
                    tiles: [
                      ListTile(
                        leading: Icon(
                          PhosphorIcons.info(),
                        ),
                        title: const Text('Sobre o App'),
                        trailing: Icon(PhosphorIcons.caretRight()),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: const AboutAppBS(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(
                          PhosphorIcons.question(),
                        ),
                        trailing: Icon(PhosphorIcons.caretRight()),
                        title: const Text('Perguntas frequentes'),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                              height: MediaQuery.of(context).size.height * 0.75,
                              child: const FAQBS(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Dados do usuário',
                    tiles: [
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.user(),
                        ),
                        title: const Text('Nome'),
                        subtitle: Text(
                          _settingsViewmodel.user!.name,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.at(),
                        ),
                        title: const Text('Email'),
                        subtitle: Text(
                          _settingsViewmodel.user!.email,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.identificationBadge(),
                        ),
                        title: const Text('Tipo de usuário'),
                        subtitle: Text(
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
                  SettingsSection(
                    title: 'Configurações',
                    tiles: [
                      SwitchListTile(
                        secondary: Icon(
                          PhosphorIcons.trash(),
                        ),
                        title: const Text(
                          'Confirmação de exclusão',
                        ),
                        value: _settingsViewmodel.enableExcludeConfirmation!,
                        onChanged: (bool value) => _settingsViewmodel
                            .setEnableExcludeConfirmation(value),
                      ),
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.paintRoller(),
                        ),
                        title: const Text('Tema'),
                        trailing: SegmentedButton<ThemeMode>(
                          showSelectedIcon: false,
                          segments: <ButtonSegment<ThemeMode>>[
                            ButtonSegment<ThemeMode>(
                                value: ThemeMode.system,
                                // label: const Text('Sistema'),
                                icon: Icon(Platform.isIOS
                                    ? PhosphorIcons.appleLogo()
                                    : PhosphorIcons.androidLogo())),
                            ButtonSegment<ThemeMode>(
                                value: ThemeMode.light,
                                // label: const Text('Claro'),
                                icon: Icon(PhosphorIcons.sun())),
                            ButtonSegment<ThemeMode>(
                                value: ThemeMode.dark,
                                // label: const Text('Escuro'),
                                icon: Icon(PhosphorIcons.moon())),
                          ],
                          selected: <ThemeMode>{_settingsViewmodel.themeMode},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            setState(() {
                              _settingsViewmodel
                                  .setThemeMode(newSelection.first);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: 'Detalhes do Aplicativo',
                    tiles: [
                      /* SettingsTile(
                        subtitle: Text(
                          GetIt.I.get<SettingsViewmodel>().savedPath.isNotEmpty
                              ? 'Localizado em: ${GetIt.I.get<SettingsViewmodel>().savedPath}'
                              : 'Salve o primeiro resultado para ver o local',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                        title: Text(_settingsViewmodel.dealWithDownloadedFiles),
                        leading: Icon(
                          PhosphorIcons.files(),
                        ),
                        trailing: Icon(PhosphorIcons.caretRight()),
                        onTap: () => _settingsViewmodel.openEnzitechFolder(),
                      ), */
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.computerTower(),
                        ),
                        title: const Text('Ambiente'),
                        subtitle: Text(
                          _settingsViewmodel.getEnviroment,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.gitBranch(),
                        ),
                        onTap: () => _settingsViewmodel
                            .openUrl(Constants.enzitechGithubPage),
                        title: const Text('Versão'),
                        subtitle: Text(
                          "${_settingsViewmodel.appInfo!.version}+${_settingsViewmodel.appInfo!.buildNumber}",
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(
                          PhosphorIcons.signOut(),
                        ),
                        title: const Text('Sair'),
                        onTap: () {
                          _homeViewmodel.experimentsViewmodel.clearFilters();
                          _settingsViewmodel.logout();
                        },
                      ),
                      GestureDetector(
                        onTap: () => _settingsViewmodel
                            .openUrl(Constants.bccCoworkingLink),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SvgPicture.asset(
                              AppSvgs(context).developedBy(),
                              alignment: Alignment.bottomCenter,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
