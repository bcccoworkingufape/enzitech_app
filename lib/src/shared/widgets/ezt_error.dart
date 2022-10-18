// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

class EZTError extends StatelessWidget {
  final String? message;
  const EZTError({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppSvgs.error,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
          ),
          if (message != null) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                message!,
                style: TextStyles.termRegular,
                textAlign: TextAlign.center,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
