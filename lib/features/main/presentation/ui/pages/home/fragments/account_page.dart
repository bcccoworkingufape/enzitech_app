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
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/failures/failures.dart';
import '../../../../../../../core/routing/routing.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../../presentation/viewmodel/home_viewmodel.dart';
import '../../../../viewmodel/fragments/account_viewmodel.dart';

// 🌎 Project imports:

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final AccountViewmodel _accountViewmodel;
  late final HomeViewmodel _homeViewmodel;

  @override
  void initState() {
    super.initState();
    _accountViewmodel = GetIt.I.get<AccountViewmodel>();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();

    if (mounted) {
      _accountViewmodel.addListener(() async {
        if (_accountViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(_accountViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        }

        if (_accountViewmodel.state == StateEnum.success &&
            _accountViewmodel.user == null &&
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

    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return AnimatedBuilder(
        animation: _accountViewmodel,
        builder: (context, child) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Builder(builder: (context) {
              if (_accountViewmodel.user == null &&
                  _accountViewmodel.state != StateEnum.error) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: heightMQ,
                width: widthMQ,
                child: Column(
                  children: [
                    Expanded(
                      child: SettingsList(
                        lightTheme: const SettingsThemeData(
                          settingsListBackground: AppColors.background,
                          titleTextColor: AppColors.grenDark,
                          leadingIconsColor: AppColors.greyBlack,
                        ),
                        sections: [
                          // ACCOUNT
                          SettingsSection(
                            title: const Text('Conta'),
                            tiles: <SettingsTile>[
                              SettingsTile(
                                leading: const Icon(
                                  PhosphorIcons.user,
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flex(
                                            direction: Axis.horizontal,
                                            children: const [Text('Nome')],
                                          )
                                        : const Text('Nome'),
                                value:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flexible(
                                            flex: 4,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                _accountViewmodel.user!.name,
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _accountViewmodel.user!.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile(
                                leading: const Icon(
                                  PhosphorIcons.at,
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flex(
                                            direction: Axis.horizontal,
                                            children: const [Text('Email')],
                                          )
                                        : const Text('Email'),
                                value:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flexible(
                                            flex: 4,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                _accountViewmodel.user!.email,
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            _accountViewmodel.user!.email,
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile(
                                leading: const Icon(
                                  PhosphorIcons.identificationBadge,
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flex(
                                            direction: Axis.horizontal,
                                            children: const [
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
                                            _accountViewmodel.user!.userType ==
                                                    UserTypeEnum.admin
                                                ? 'Administrador'
                                                : 'Comum',
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _accountViewmodel.user!.userType ==
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
                            title: const Text('Preferências'),
                            tiles: [
                              SettingsTile.switchTile(
                                initialValue:
                                    _accountViewmodel.enableExcludeConfirmation,
                                onToggle: (value) => _accountViewmodel
                                    .setEnableExcludeConfirmation(value),
                                leading: const Icon(
                                  PhosphorIcons.trash,
                                ),
                                title: const Text('Confirmação de exclusão'),
                              ),
                            ],
                          ),
                          // APP
                          SettingsSection(
                            title: const Text('App'),
                            tiles: [
                              SettingsTile(
                                leading: const Icon(
                                  PhosphorIcons.gitBranch,
                                ),
                                title:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Flex(
                                            direction: Axis.horizontal,
                                            children: const [
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
                                                "${_accountViewmodel.appInfo!.version}+${_accountViewmodel.appInfo!.buildNumber}",
                                                overflow: TextOverflow.ellipsis,
                                                style: descriptionTextStyle,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            "${_accountViewmodel.appInfo!.version}+${_accountViewmodel.appInfo!.buildNumber}",
                                            overflow: TextOverflow.ellipsis,
                                            style: descriptionTextStyle,
                                          ),
                              ),
                              SettingsTile.navigation(
                                leading: const Icon(
                                  PhosphorIcons.signOut,
                                  color: AppColors.danger,
                                ),
                                trailing:
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? Icon(
                                            CupertinoIcons.chevron_forward,
                                            size: 18 * scaleFactor,
                                            color: AppColors.danger,
                                          )
                                        : null,
                                title: const Text(
                                  'Sair',
                                  style: TextStyle(color: AppColors.danger),
                                ),
                                onPressed: (_) {
                                  _homeViewmodel.experimentsViewmodel
                                      .clearFilters();
                                  _accountViewmodel.logout();
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: _accountViewmodel.openUrl,
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
