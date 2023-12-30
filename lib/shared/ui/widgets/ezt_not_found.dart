// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import '../themes/themes.dart';

class EZTNotFound extends StatelessWidget {
  final String? message;
  final String? title;

  const EZTNotFound({super.key, this.message, this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppSvgs(context).notFound(),
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
          ),
          if (title != null) ...[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                title!,
                style: TextStyles.informationExperimentStepTitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ],
          if (message != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                message!,
                style: TextStyles.termRegular,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 16,
            )
          ]
        ],
      ),
    );
  }
}
