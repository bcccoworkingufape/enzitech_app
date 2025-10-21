// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../features/main/presentation/viewmodel/home_viewmodel.dart';
import '../../../features/main/presentation/viewmodel/settings_viewmodel.dart';
import '../../extensions/build_context_extensions.dart';
import '../ui.dart';
import 'ezt_blink.dart';

class EZTAppBar extends StatefulWidget implements PreferredSizeWidget {
  final HomeViewmodel homeViewmodel;
  const EZTAppBar({super.key, required this.homeViewmodel});

  @override
  State<EZTAppBar> createState() => _EZTAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EZTAppBarState extends State<EZTAppBar> {
  @override
  void initState() {
    super.initState();
  }

  static noInternet(context) {
    return EZTSnackBar.show(
      context,
      "⚠ Sem conexão com o servidor: Você está visualizando informações previamente carregadas e sem atualizações, quaisquer mudanças offline não serão mantidas!",
      eztSnackBarType: EZTSnackBarType.error,
      duration: const Duration(seconds: 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GetIt.I.get<SettingsViewmodel>(),
      builder: (context, _) {
        return AppBar(
          title: SvgPicture.asset(
            AppSvgs(context).logo(),
            colorFilter: context.isDarkMode
                ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                : ColorFilter.mode(context.getApplyedColorScheme.primary, BlendMode.srcIn),
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          actions: [
            !widget.homeViewmodel.hasInternetConnection
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => noInternet(context),
                      child: EZTBlink(
                        interval: 750,
                        children: <Widget>[
                          Icon(PhosphorIcons.cloudSlash(), color: Colors.white),

                          Icon(PhosphorIcons.cloudSlash(), color: context.getApplyedColorScheme.error),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
