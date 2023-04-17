import 'package:flutter/material.dart';

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
          Text(
            "Sobre:",
            style: TextStyles.titleHome,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            "Idealização",
            style: TextStyles.titleBoldHeading,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: 'O ',
              style: TextStyles.trailingRegular,
              children: <TextSpan>[
                TextSpan(
                  text: 'Enzitech',
                  style: TextStyles.trailingRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      ' foi concebido como uma solução para o estudo e realização de experimentos no campo das atividades enzimáticas do solo, idealizado em conjunto pelo ',
                  style: TextStyles.trailingRegular,
                ),
                TextSpan(
                  text: 'Laboratório BCC Coworking',
                  style: TextStyles.trailingRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ' e o ',
                  style: TextStyles.trailingRegular,
                ),
                TextSpan(
                  text: 'Laboratório de Pesquisa em Solo',
                  style: TextStyles.trailingRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: ', localizados na ',
                  style: TextStyles.trailingRegular,
                ),
                TextSpan(
                  text: 'Universidade Federal do Agreste de Pernambuco (UFAPE)',
                  style: TextStyles.trailingRegular
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '.',
                  style: TextStyles.trailingRegular,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            "Equipe de desenvolvimento",
            style: TextStyles.titleBoldHeading,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: '• Armstrong Lohãns ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Desenvolvedor mobile)',
                  style: TextStyles.trailingRegular,
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
              text: '• Matheus Noronha ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                    text: '(Desenvolvedor back-end)',
                    style: TextStyles.trailingRegular),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              text: '• Weverton Cintra ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Desenvolvedor back-end)',
                  style: TextStyles.trailingRegular,
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
              text: '• José Vieira ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Desenvolvedor mobile)',
                  style: TextStyles.trailingRegular,
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
              text: '• Eduarda Interaminense ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Gestão do Projeto)',
                  style: TextStyles.trailingRegular,
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
              text: '• Rodrigo Rocha ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Docente - BCC)',
                  style: TextStyles.trailingRegular,
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
              text: '• Jean Teixeira ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Docente - BCC)',
                  style: TextStyles.trailingRegular,
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
              text: '• Igor Medeiros ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Docente - BCC)',
                  style: TextStyles.trailingRegular,
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
              text: '• Erika Valente ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Docente - Agronomia)',
                  style: TextStyles.trailingRegular,
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
              text: '• Jamille Barros ',
              style: TextStyles.trailingRegular
                  .copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: '(Docente - Agronomia)',
                  style: TextStyles.trailingRegular,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: EZTButton(
              text: 'Fechar',
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
