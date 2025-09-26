// 🐦 Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../../../l10n/app_localizations.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../widgets/ezt_bottomsheet.dart';

// 📦 Package imports:

class FAQBS extends StatelessWidget {
  const FAQBS({super.key});

  @override
  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    return EZTBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.frequentlyAskedQuestions,
            style: TextStyles.titleHome,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyles(context).trailingRegular(),
              children: <TextSpan>[
                TextSpan(
                  text: l10n.question,
                  style: TextStyles(context).trailingRegular(isBold: true),
                ),
                TextSpan(
                  text: l10n.question1,
                  style: TextStyles(context).trailingRegular(
                    isBold: true,
                    color: context.getApplyedColorScheme.error,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyles(context).trailingRegular(),
              children: <TextSpan>[
                TextSpan(
                  text: l10n.answer,
                  style: TextStyles(context).trailingRegular(isBold: true),
                ),
                TextSpan(
                  text:
                      l10n.answer1,
                  style: TextStyles(context).trailingRegular(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: EZTButton(
              text: l10n.closeButton,
              eztButtonType: EZTButtonType.outline,
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
