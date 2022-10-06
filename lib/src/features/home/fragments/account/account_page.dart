// 🐦 Flutter imports:

// 🎯 Dart imports:
import 'dart:io' show Platform;

// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  final HomeController homeController;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late final AccountController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<AccountController>();

    if (mounted) {
      controller.addListener(() async {
        if (controller.state == AccountState.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(controller.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        }

        if (controller.state == AccountState.success &&
            controller.user == null &&
            mounted) {
          EZTSnackBar.show(context, "Até logo...");
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            Navigator.pushReplacementNamed(context, RouteGenerator.auth);
            widget.homeController.setFragmentIndex(0);
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

    final controller = context.watch<AccountController>();
    final scaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Builder(builder: (context) {
        if (controller.user == null && controller.state != AccountState.error) {
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
                    SettingsSection(
                      title: const Text('Conta'),
                      tiles: <SettingsTile>[
                        SettingsTile(
                          leading: const Icon(
                            PhosphorIcons.user,
                          ),
                          title: Platform.isIOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [Text('Nome')],
                                )
                              : const Text('Nome'),
                          value: Platform.isIOS
                              ? Flexible(
                                  flex: 4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      controller.user!.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  controller.user!.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: descriptionTextStyle,
                                ),
                        ),
                        SettingsTile(
                          leading: const Icon(
                            PhosphorIcons.at,
                          ),
                          title: Platform.isIOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [Text('Email')],
                                )
                              : const Text('Email'),
                          value: Platform.isIOS
                              ? Flexible(
                                  flex: 4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      controller.user!.email,
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  controller.user!.email,
                                  overflow: TextOverflow.ellipsis,
                                  style: descriptionTextStyle,
                                ),
                        ),
                        SettingsTile(
                          leading: const Icon(
                            PhosphorIcons.identificationBadge,
                          ),
                          title: Platform.isIOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [
                                    Text('Tipo de usuário'),
                                  ],
                                )
                              : const Text('Tipo de usuário'),
                          value: Platform.isIOS
                              ? Flexible(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      controller.user!.userType ==
                                              UserTypeEnum.admin
                                          ? 'Administrador'
                                          : 'Comum',
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  controller.user!.userType ==
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
                      title: const Text('App'),
                      tiles: [
                        SettingsTile(
                          leading: const Icon(
                            PhosphorIcons.gitBranch,
                          ),
                          title: Platform.isIOS
                              ? Flex(
                                  direction: Axis.horizontal,
                                  children: const [
                                    Text('Versão'),
                                  ],
                                )
                              : const Text('Versão'),
                          value: Platform.isIOS
                              ? Flexible(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "${controller.appInfo!.version}+${controller.appInfo!.buildNumber}",
                                      overflow: TextOverflow.ellipsis,
                                      style: descriptionTextStyle,
                                    ),
                                  ),
                                )
                              : Text(
                                  "${controller.appInfo!.version}+${controller.appInfo!.buildNumber}",
                                  overflow: TextOverflow.ellipsis,
                                  style: descriptionTextStyle,
                                ),
                        ),
                        SettingsTile.navigation(
                          leading: const Icon(
                            PhosphorIcons.signOut,
                            color: AppColors.danger,
                          ),
                          trailing: Platform.isIOS
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
                          onPressed: (_) => controller.logout(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: controller.openUrl,
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
