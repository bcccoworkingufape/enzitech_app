// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

class EZTCreateExperimentStepIndicator extends StatelessWidget {
  final String title;
  final String message;
  const EZTCreateExperimentStepIndicator(
      {super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppSvgs.iconLogo,
            alignment: Alignment.center,
            width: 75,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                title,
                style: TextStyles.informationExperimentStepTitle,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                message,
                style: TextStyles.informationExperimentStepMessage,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const SizedBox(height: 64),
      ],
    );
  }
}
