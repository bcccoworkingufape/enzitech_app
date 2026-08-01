// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../widgets/ezt_bottomsheet.dart';

class AboutAppBS extends StatelessWidget {
  const AboutAppBS({super.key});

  @override
  Widget build(BuildContext context) {
    return EZTBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.aboutTitle, style: TextStyles.titleHome, textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Text(
            context.l10n.idealizationTitle,
            style: TextStyles(context).titleBoldHeading,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: 'O ',
              style: TextStyles(context).trailingRegular(),
              children: <TextSpan>[
                TextSpan(text: 'Enzitech', style: TextStyles(context).trailingRegular(isBold: true)),
                TextSpan(text: context.l10n.idealizationTextP1, style: TextStyles(context).trailingRegular()),
                TextSpan(text: 'Laboratório BCC Coworking', style: TextStyles(context).trailingRegular(isBold: true)),
                TextSpan(text: context.l10n.idealizationTextP2, style: TextStyles(context).trailingRegular()),
                TextSpan(
                  text: 'Laboratório de Enzimologia e Microbiologia Ambiental(LEMA)',
                  style: TextStyles(context).trailingRegular(isBold: true),
                ),
                TextSpan(text: context.l10n.idealizationTextP3, style: TextStyles(context).trailingRegular()),
                TextSpan(
                  text: 'Universidade Federal do Agreste de Pernambuco (UFAPE)',
                  style: TextStyles(context).trailingRegular(isBold: true),
                ),
                TextSpan(text: '.', style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            context.l10n.developmentTeamTitle,
            style: TextStyles(context).titleBoldHeading,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Armstrong Lohãns ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleMobileDeveloper, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Matheus Noronha ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleBackendDeveloper, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Weverton Cintra ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleBackendDeveloper, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• José Vieira ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleMobileDeveloper, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Guilherme Felix ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleMobileDeveloper, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Eduarda Interaminense ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleProjectManagement, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Rodrigo Rocha ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleProfessorBCC, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Jean Teixeira ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleProfessorBCC, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Igor Medeiros ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleProfessorBCC, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Erika Valente ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleProfessorAgronomy, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: '• Jamille Barros ',
              style: TextStyles(context).trailingRegular(isBold: true),
              children: <TextSpan>[
                TextSpan(text: context.l10n.roleProfessorAgronomy, style: TextStyles(context).trailingRegular()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: EZTButton(
              text: context.l10n.closeButton,
              eztButtonType: EZTButtonType.outline,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
