// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../widgets/ezt_bottomsheet.dart';

// 📦 Package imports:

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
