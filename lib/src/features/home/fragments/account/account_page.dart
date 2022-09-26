// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
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

        if (controller.state == AccountState.success && mounted) {
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
    var customTextStyle = const TextStyle(
      color: Color(0xFF97979A),
      fontSize: 17,
      fontWeight: FontWeight.w400,
    );

    final controller = context.watch<AccountController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        height: heightMQ,
        width: widthMQ,
        child: Column(
          children: [
            Expanded(
              child: SettingsList(
                lightTheme: const SettingsThemeData(
                  settingsListBackground: AppColors.background,
                ),
                sections: [
                  SettingsSection(
                    title: const Text('Conta'),
                    tiles: <SettingsTile>[
                      SettingsTile(
                        leading: const Icon(PhosphorIcons.user),
                        title: const Text('Usuário'),
                        value: Text(
                          controller.username ?? 'Não definido',
                          style: customTextStyle,
                        ),
                      ),
                      SettingsTile(
                        leading: const Icon(PhosphorIcons.at),
                        title: const Text(
                          'Email',
                        ),
                        value: Flexible(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              controller.email ?? 'Não definido',
                              overflow: TextOverflow.ellipsis,
                              style: customTextStyle,
                            ),
                          ),
                        ),
                      ),
                      SettingsTile.navigation(
                        leading: const Icon(PhosphorIcons.signOut),
                        title: const Text(
                          'Sair',
                        ),
                        onPressed: (_) => controller.logout(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => url_launcher.launchUrl(
                Uri.parse(Constants.bccCoworkingLink),
              ),
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
      ),
    );
  }
}
