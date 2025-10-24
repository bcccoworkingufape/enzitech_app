// 🎯 Dart imports:
import 'dart:io';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/extensions.dart';
import '../../../../../../shared/l10n/app_localizations.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../viewmodel/home_viewmodel.dart';
import '../../../viewmodel/settings_viewmodel.dart';
import '../../widgets/settings_section.dart';
import 'fragments/about_app_bs.dart';
import 'fragments/faq_bs.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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

    if (mounted) {
      _settingsViewmodel.addListener(() async {
        if (_settingsViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(context.l10n, _settingsViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        }

        if (_settingsViewmodel.state == StateEnum.success && _settingsViewmodel.user == null && mounted) {
          EZTSnackBar.clear(context);
          EZTSnackBar.show(context, context.l10n.seeYouSoon);
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

  get descriptionTextStyle => const TextStyle(color: Color(0xFF97979A), fontSize: 17, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    final envEnum = _settingsViewmodel.environment;
    final translatedEnvValue = context.l10n.environmentValue(envEnum.name);
    return ListenableBuilder(
      listenable: _settingsViewmodel,
      builder: (context, child) {
        return Scaffold(
          body: Builder(
            builder: (context) {
              if (_settingsViewmodel.user == null && _settingsViewmodel.state != StateEnum.error) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: [
                  SettingsSection(
                    title: context.l10n.info,
                    tiles: [
                      ListTile(
                        leading: Icon(PhosphorIcons.info()),
                        title: Text(context.l10n.about),
                        trailing: Icon(PhosphorIcons.caretRight()),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                            context: context,
                            builder: (BuildContext context) =>
                                SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: const AboutAppBS()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(PhosphorIcons.question()),
                        trailing: Icon(PhosphorIcons.caretRight()),
                        title: Text(context.l10n.frequentlyAskedQuestions),
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                            context: context,
                            builder: (BuildContext context) =>
                                SizedBox(height: MediaQuery.of(context).size.height * 0.75, child: const FAQBS()),
                          );
                        },
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: context.l10n.userData,
                    tiles: [
                      SettingsTile(
                        leading: Icon(PhosphorIcons.user()),
                        title: Text(context.l10n.userName),
                        subtitle: Text(
                          _settingsViewmodel.user!.name,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(PhosphorIcons.at()),
                        title: Text(context.l10n.email),
                        subtitle: Text(
                          _settingsViewmodel.user!.email,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(PhosphorIcons.identificationBadge()),
                        title: Text(context.l10n.userType),
                        subtitle: Text(
                          context.l10n.roles(_settingsViewmodel.user!.userType.name),
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: context.l10n.settings,
                    tiles: [
                      SwitchListTile(
                        secondary: Icon(PhosphorIcons.globe()),
                        title: Text(context.l10n.replaceLanguage),
                        value: _settingsViewmodel.isReplaceLanguage,
                        onChanged: (bool value) => _settingsViewmodel.setReplaceLanguage(value),
                      ),
                      Opacity(
                        opacity: _settingsViewmodel.isReplaceLanguage
                            ? 1.0
                            : 0.5, // Reduce opacity to indicate disabled state
                        child: SettingsTile(
                          leading: Icon(PhosphorIcons.quotes()),
                          title: Text(context.l10n.languages),
                          trailing: SegmentedButton<Locale>(
                            showSelectedIcon: false,
                            segments: _settingsViewmodel.locales.map((locale) {
                              return ButtonSegment<Locale>(
                                value: locale,
                                icon: Text(locale.languageCode.toUpperCase()),
                              );
                            }).toList(),
                            selected: <Locale>{Locale(AppLocalizations.of(context).localeName)},
                            onSelectionChanged: (Set<Locale> newSelection) {
                              setState(() {
                                _settingsViewmodel.setLocale(newSelection.first);
                              });
                            },
                          ),
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(PhosphorIcons.paintRoller()),
                        title: Text(context.l10n.theme),
                        trailing: SegmentedButton<ThemeMode>(
                          showSelectedIcon: false,
                          segments: <ButtonSegment<ThemeMode>>[
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.system,
                              icon: Icon(Platform.isIOS ? PhosphorIcons.appleLogo() : PhosphorIcons.androidLogo()),
                            ),
                            ButtonSegment<ThemeMode>(value: ThemeMode.light, icon: Icon(PhosphorIcons.sun())),
                            ButtonSegment<ThemeMode>(value: ThemeMode.dark, icon: Icon(PhosphorIcons.moon())),
                          ],
                          selected: <ThemeMode>{_settingsViewmodel.themeMode},
                          onSelectionChanged: (Set<ThemeMode> newSelection) {
                            setState(() {
                              _settingsViewmodel.setThemeMode(newSelection.first);
                            });
                          },
                        ),
                      ),
                      SwitchListTile(
                        secondary: Icon(PhosphorIcons.trash()),
                        title: Text(context.l10n.deletionConfirmation),
                        value: _settingsViewmodel.enableExcludeConfirmation!,
                        onChanged: (bool value) => _settingsViewmodel.setEnableExcludeConfirmation(value),
                      ),
                    ],
                  ),
                  SettingsSection(
                    title: context.l10n.details,
                    tiles: [
                      SettingsTile(
                        leading: Icon(PhosphorIcons.computerTower()),
                        title: Text(context.l10n.environment),
                        subtitle: Text(
                          translatedEnvValue,
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(PhosphorIcons.gitBranch()),
                        onTap: () async {
                          try {
                            await _settingsViewmodel.openUrl(Constants.enzitechGithubPage);
                          } on UnableToOpenUrlFailure catch (e) {
                            EZTSnackBar.show(context, context.l10n.unableToOpenUrlError(e.message));
                          }
                        },
                        title: Text(context.l10n.version),
                        subtitle: Text(
                          "${_settingsViewmodel.appInfo!.version}+${_settingsViewmodel.appInfo!.buildNumber}",
                          overflow: TextOverflow.ellipsis,
                          style: descriptionTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: Icon(PhosphorIcons.signOut()),
                        title: Text(context.l10n.exit),
                        onTap: () {
                          _homeViewmodel.experimentsViewmodel.clearFilters();
                          _settingsViewmodel.logout();
                        },
                      ),
                      GestureDetector(
                        onTap: () => _settingsViewmodel.openUrl(Constants.bccCoworkingLink),
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
