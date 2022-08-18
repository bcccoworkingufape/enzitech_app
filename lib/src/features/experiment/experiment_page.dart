// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../shared/themes/app_complete_theme.dart';
import '../../shared/widgets/ezt_button.dart';

class ExperimentPage extends StatefulWidget {
  const ExperimentPage({Key? key}) : super(key: key);

  @override
  State<ExperimentPage> createState() => _ExperimentPageState();
}

class _ExperimentPageState extends State<ExperimentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Experimento 1",
          style: TextStyles.titleBoldBackground,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIcons.trash,
                color: AppColors.white, size: 25),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(
          "Editar\nExperimento",
          style: TextStyles.buttonBoldBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          size: 35,
          color: AppColors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CircularPercentIndicator(
                radius: 60,
                lineWidth: 10.0,
                percent: 0.8,
                center: Text(
                  '80%',
                  style: TextStyles.titleBoldHeading,
                ),
                progressColor: AppColors.primary,
                backgroundColor: AppColors.primary.withOpacity(0.4),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Descrição opcional do experimento aqui...",
                style: TextStyles.detailRegular,
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(color: AppColors.grey),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "3",
                        style: TextStyles.titleHome,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Enzimas",
                        style: TextStyles.detailRegular,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      Text(
                        "3",
                        style: TextStyles.titleHome,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Tratamentos",
                        style: TextStyles.detailRegular,
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    children: [
                      Text(
                        "3",
                        style: TextStyles.titleHome,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Repetições",
                        style: TextStyles.detailRegular,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(color: AppColors.grey),
              const SizedBox(
                height: 20,
              ),
              EZTButton(
                text: 'Inserir Dados',
                eztButtonType: EZTButtonType.checkout,
                icon: const Icon(PhosphorIcons.pencilLine,
                    color: AppColors.white, size: 30),
                onPressed: () {},
              ),
              const SizedBox(
                height: 20,
              ),
              EZTButton(
                text: 'Resultados',
                eztButtonType: EZTButtonType.checkout,
                icon: const Icon(PhosphorIcons.fileText,
                    color: AppColors.white, size: 30),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
