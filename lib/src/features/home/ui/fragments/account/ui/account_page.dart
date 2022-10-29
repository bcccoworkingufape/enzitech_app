// 🐦 Flutter imports:

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/ui/fragments/account/viewmodel/account_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/user_type_enum.dart';
import 'package:enzitech_app/src/shared/business/infra/implementations/providers/app_providers.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
    required this.homeViewmodel,
  }) : super(key: key);

  final HomeViewmodel homeViewmodel;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final AccountViewmodel viewmodel;

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<AccountViewmodel>();

    if (mounted) {
      viewmodel.addListener(() async {
        if (viewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(viewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        }

        if (viewmodel.state == StateEnum.success &&
            viewmodel.user == null &&
            mounted) {
          EZTSnackBar.clear(context);
          EZTSnackBar.show(context, "Até logo...");
          await Future.delayed(const Duration(milliseconds: 250));
          if (mounted) {
            Navigator.pushReplacementNamed(context, RouteGenerator.auth);
            widget.homeViewmodel.setFragmentIndex(0);
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

    final viewmodel = context.watch<AccountViewmodel>();
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Builder(builder: (context) {
        if (viewmodel.user == null && viewmodel.state != StateEnum.error) {
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
                          title: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [Text('Nome')],
                                )
                              : const Text('Nome'),
                          value: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flexible(
                                  flex: 4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      viewmodel.user!.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  viewmodel.user!.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: descriptionTextStyle,
                                ),
                        ),
                        SettingsTile(
                          leading: const Icon(
                            PhosphorIcons.at,
                          ),
                          title: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [Text('Email')],
                                )
                              : const Text('Email'),
                          value: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flexible(
                                  flex: 4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      viewmodel.user!.email,
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  viewmodel.user!.email,
                                  overflow: TextOverflow.ellipsis,
                                  style: descriptionTextStyle,
                                ),
                        ),
                        SettingsTile(
                          leading: const Icon(
                            PhosphorIcons.identificationBadge,
                          ),
                          title: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [
                                    Text('Tipo de usuário'),
                                  ],
                                )
                              : const Text('Tipo de usuário'),
                          value: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flexible(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      viewmodel.user!.userType ==
                                              UserTypeEnum.admin
                                          ? 'Administrador'
                                          : 'Comum',
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  viewmodel.user!.userType == UserTypeEnum.admin
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
                          initialValue: viewmodel.enableExcludeConfirmation,
                          onToggle: (value) =>
                              viewmodel.setEnableExcludeConfirmation(value),
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
                          title: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [
                                    Text('Versão'),
                                  ],
                                )
                              : const Text('Versão'),
                          value: defaultTargetPlatform == TargetPlatform.iOS
                              ? Flexible(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${viewmodel.appInfo!.version}+${viewmodel.appInfo!.buildNumber}",
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  "${viewmodel.appInfo!.version}+${viewmodel.appInfo!.buildNumber}",
                                  overflow: TextOverflow.ellipsis,
                                  style: descriptionTextStyle,
                                ),
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(
                            PhosphorIcons.signOut,
                            color: AppColors.danger,
                          ),
                          trailing: defaultTargetPlatform == TargetPlatform.iOS
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
                            viewmodel.logout();
                            AppProviders.disposeAllDisposableProviders(context);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: viewmodel.openUrl,
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
  }
}
