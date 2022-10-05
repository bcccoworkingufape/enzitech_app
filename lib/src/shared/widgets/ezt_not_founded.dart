// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

class EZTNotFounded extends StatelessWidget {
  final String? message;
  const EZTNotFounded({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppSvgs.notFound,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
          ),
          if (message != null)
            Text(
              message!,
              style: TextStyles.termRegular,
            ),
        ],
      ),
    );
  }
}
