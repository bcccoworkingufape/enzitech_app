import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../../shared/ui/ui.dart';
import '../../../../../../experiment/presentation/viewmodel/experiment_results_viewmodel.dart';
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
              style: TextStyles.trailingRegular,
              children: <TextSpan>[
                TextSpan(
                  text: 'Pergunta: ',
                  style: TextStyles.trailingRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: AppColors.danger, //TODO: COLOR-FIX
                  ),
                ),
                TextSpan(
                  text: 'Não consigo criar enzimas',
                  style: TextStyles.trailingRegular.copyWith(
                    fontWeight: FontWeight.bold,
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
              style: TextStyles.trailingRegular,
              children: <TextSpan>[
                TextSpan(
                  text: 'Resposta: ',
                  style: TextStyles.trailingRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: AppColors.info, //TODO: COLOR-FIX
                  ),
                ),
                TextSpan(
                  text:
                      'A funcionalidade de criação de enzimas é restrita ao adminstrador do Enzitech, pois atualmente para o cadastro de uma enzima é necessário sua implementação até que a mesma possa estar disponível para uso, caso necessite de algum novo tipo de enzima solicite ao administrador do sistema.',
                  style: TextStyles.trailingRegular,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyles.trailingRegular,
              children: <TextSpan>[
                TextSpan(
                  text: 'Pergunta: ',
                  style: TextStyles.trailingRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: AppColors.danger, //TODO: COLOR-FIX
                  ),
                ),
                TextSpan(
                  text:
                      'Não consigo baixar a planilha de resultados do experimento',
                  style: TextStyles.trailingRegular.copyWith(
                    fontWeight: FontWeight.bold,
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
              style: TextStyles.trailingRegular,
              children: <TextSpan>[
                TextSpan(
                  text: 'Resposta: ',
                  style: TextStyles.trailingRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    // color: AppColors.info, //TODO: COLOR-FIX
                  ),
                ),
                TextSpan(
                  text:
                      'Utilizando algum gerenciador de arquivos, verifique o diretório localizado em: ',
                  style: TextStyles.trailingRegular,
                ),
                GetIt.I.get<ExperimentResultsViewmodel>().savedPath.isNotEmpty
                    ? TextSpan(
                        text:
                            GetIt.I.get<ExperimentResultsViewmodel>().savedPath,
                        style: TextStyles.trailingRegular.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : TextSpan(
                        text:
                            "(Diretório ainda não identificado, tente salvar um experimento para que o app possa detectar o local)",
                        style: TextStyles.trailingRegular.copyWith(
                          fontWeight: FontWeight.bold,
                          // color: AppColors.warning, //TODO: COLOR-FIX
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                TextSpan(
                  text:
                      ' e limpe todas as planilhas existentes! \nApós excluídos ou movidos desta pasta, a função de salvar voltará a funcionar corretamente; isto acontece devido a limitações das novas regras de privacidade do Android, desta forma, este aplicativo não tem autorização de apagar arquivos criados por instalações anteriores ou de outras fontes, causando este erro.',
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
