// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:

// 🌎 Project imports:
import '../../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../widgets/ezt_bottomsheet.dart';

class FAQBS extends StatelessWidget {
  const FAQBS({super.key});

  @override
  Widget build(BuildContext context) {
    return EZTBottomSheet(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Perguntas frequentes:",
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
                  text: 'Pergunta: ',
                  style: TextStyles(context).trailingRegular(isBold: true),
                ),
                TextSpan(
                  text: 'Não consigo criar enzimas',
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
                  text: 'Resposta: ',
                  style: TextStyles(context).trailingRegular(isBold: true),
                ),
                TextSpan(
                  text:
                      'A funcionalidade de criação de enzimas é restrita ao adminstrador do Enzitech, pois atualmente para o cadastro de uma enzima é necessário sua implementação até que a mesma possa estar disponível para uso, caso necessite de algum novo tipo de enzima solicite ao administrador do sistema.',
                  style: TextStyles(context).trailingRegular(),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 32,
          // ),
          // RichText(
          //   textAlign: TextAlign.justify,
          //   text: TextSpan(
          //     style: TextStyles(context).trailingRegular(),
          //     children: <TextSpan>[
          //       TextSpan(
          //         text: 'Pergunta: ',
          //         style: TextStyles(context).trailingRegular(isBold: true),
          //       ),
          //       TextSpan(
          //         text:
          //             'Não consigo baixar a planilha de resultados do experimento',
          //         style: TextStyles(context).trailingRegular(isBold: true),
          //       ),
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          // RichText(
          //   textAlign: TextAlign.justify,
          //   text: TextSpan(
          //     style: TextStyles(context).trailingRegular(),
          //     children: <TextSpan>[
          //       TextSpan(
          //         text: 'Resposta: ',
          //         style: TextStyles(context).trailingRegular(isBold: true),
          //       ),
          //       TextSpan(
          //         text:
          //             'Utilizando algum gerenciador de arquivos, verifique o diretório localizado em: ',
          //         style: TextStyles(context).trailingRegular(),
          //       ),
          //       GetIt.I.get<SettingsViewmodel>().savedPath.isNotEmpty
          //           ? TextSpan(
          //               text: GetIt.I.get<SettingsViewmodel>().savedPath,
          //               style:
          //                   TextStyles(context).trailingRegular(isBold: true),
          //             )
          //           : TextSpan(
          //               text:
          //                   "(Diretório ainda não identificado, tente salvar um experimento para que o app possa detectar o local)",
          //               style: TextStyles(context).trailingRegular(
          //                 isBold: true,
          //                 fontStyle: FontStyle.italic,
          //               ),
          //             ),
          //       TextSpan(
          //         text:
          //             ' e limpe todas as planilhas existentes! \nApós excluídos ou movidos desta pasta, a função de salvar voltará a funcionar corretamente; isto acontece devido a limitações das novas regras de privacidade do Android, desta forma, este aplicativo não tem autorização de apagar arquivos criados por instalações anteriores ou de outras fontes, causando este erro.',
          //         style: TextStyles(context).trailingRegular(),
          //       ),
          //     ],
          //   ),
          // ),
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
