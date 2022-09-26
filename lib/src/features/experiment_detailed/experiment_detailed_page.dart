// 🐦 Flutter imports:
// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_detailed/experiment_detailed_controller.dart';
import '../../shared/failures/failures.dart';
import '../../shared/models/experiment_model.dart';
import '../../shared/themes/app_complete_theme.dart';
import '../../shared/util/util.dart';
import '../../shared/widgets/ezt_button.dart';
import '../../shared/widgets/ezt_snack_bar.dart';
import '../home/fragments/experiments/experiments_controller.dart';

class ExperimentDetailedPage extends StatefulWidget {
  const ExperimentDetailedPage({
    Key? key,
    required this.resumedExperiment,
  }) : super(key: key);

  final ExperimentModel resumedExperiment;

  @override
  State<ExperimentDetailedPage> createState() => _ExperimentDetailedPageState();
}

class _ExperimentDetailedPageState extends State<ExperimentDetailedPage> {
  late final ExperimentDetailedController controller;
  late final ExperimentsController experimentsController;

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentDetailedController>();
    experimentsController = context.read<ExperimentsController>();

    if (mounted) {
      controller.addListener(
        () {
          if (mounted && controller.state == ExperimentDetailedState.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }

    controller.getExperimentDetailed(widget.resumedExperiment.id);
  }

  Widget _buildBody(double height) {
    if (controller.state == ExperimentDetailedState.error) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.75,
              child: Center(
                child: Text(
                    'Erro ao carregar experimento "${widget.resumedExperiment.name}"'),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.state == ExperimentDetailedState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    // if (controller.state == ExperimentDetailedState.success &&
    //     controller.treatments.isEmpty) {
    //   return SingleChildScrollView(
    //     physics: const AlwaysScrollableScrollPhysics(),
    //     child: Column(
    //       children: [
    //         SizedBox(
    //           height: height / 1.35,
    //           child: const Center(
    //             child: Text("Tratamentos não encontrados"),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        CircularPercentIndicator(
          radius: 60,
          lineWidth: 10.0,
          percent: widget.resumedExperiment.progress,
          center: Text(
            Toolkit.doubleToPercentual(widget.resumedExperiment.progress * 100),
            style: TextStyles.titleBoldHeading,
          ),
          progressColor: AppColors.primary,
          backgroundColor: AppColors.primary.withOpacity(0.4),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          widget.resumedExperiment.description,
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
                  controller.experiment!.enzymes!.length.toString(),
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
                  controller.experiment!.treatments!.length.toString(),
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
                  controller.experiment!.repetitions.toString(),
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
          onPressed: () => print(""),
        ),
        const SizedBox(
          height: 20,
        ),
        EZTButton(
          text: 'Resultados',
          eztButtonType: EZTButtonType.checkout,
          icon: const Icon(PhosphorIcons.fileText,
              color: AppColors.white, size: 30),
          onPressed: () => print(""),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentDetailedController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          widget.resumedExperiment.name,
          style: TextStyles.titleBoldBackground,
        ),
        actions: [
          IconButton(
            onPressed: () {
              experimentsController.deleteExperiment(controller.experiment!.id);
              experimentsController.experiments
                  .removeWhere((exp) => exp.id == controller.experiment!.id);
              experimentsController.notifyListeners();

              Navigator.pop(context);

              EZTSnackBar.clear(context);
              EZTSnackBar.show(
                context,
                '${controller.experiment!.name} excluído!',
                eztSnackBarType: EZTSnackBarType.error,
              );
            },
            icon: const Icon(
              PhosphorIcons.trash,
              color: AppColors.white,
              size: 25,
            ),
          ),
        ],
      ),
      /* floatingActionButton: FloatingActionButton.extended(
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
      ), */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: _buildBody(
          MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}