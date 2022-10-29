// 🐦 Flutter imports:
// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_detailed/viewmodel/experiment_detailed_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class ExperimentDetailedPage extends StatefulWidget {
  const ExperimentDetailedPage({
    Key? key,
    required this.resumedExperiment,
  }) : super(key: key);

  final ExperimentEntity resumedExperiment;

  @override
  State<ExperimentDetailedPage> createState() => _ExperimentDetailedPageState();
}

class _ExperimentDetailedPageState extends State<ExperimentDetailedPage> {
  late final ExperimentDetailedViewmodel viewmodel;
  late final ExperimentsViewmodel experimentsViewmodel;
  bool _expandToSeeMoreVisible = true;

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<ExperimentDetailedViewmodel>();
    experimentsViewmodel = context.read<ExperimentsViewmodel>();

    if (mounted) {
      viewmodel.addListener(
        () {
          if (mounted && viewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(viewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }

    viewmodel.getExperimentDetailed(widget.resumedExperiment.id);
  }

  get leadWithEnzymes {
    if (viewmodel.experiment!.enzymes != null) {
      if (viewmodel.experiment!.enzymes!.isNotEmpty) {
        return viewmodel.experiment!.enzymes!
            .map((element) => Text(element.name))
            .toList();
      }
    }
    return const [Text("Sem dados!")];
  }

  get leadWithTreatments {
    if (viewmodel.experiment!.treatments != null) {
      if (viewmodel.experiment!.treatments!.isNotEmpty) {
        return viewmodel.experiment!.treatments!
            .map((element) => Text(element.name))
            .toList();
      }
    }
    return const [Text("Sem dados!")];
  }

  Widget _buildBody(double height) {
    if (viewmodel.state == StateEnum.error) {
      return EZTError(
        message:
            'Erro ao carregar o experimento "${widget.resumedExperiment.name}"',
      );
    }

    if (viewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(
        message: "Carregando experimento...",
      );
    }

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
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: EZTExpansionTile(
            // trailing: Text("test"),
            disableTrailing: true,
            onExpansionChanged: (_) {
              setState(() {
                _expandToSeeMoreVisible = !_expandToSeeMoreVisible;
              });
            },
            title: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            viewmodel.experiment!.treatments!.length.toString(),
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
                            viewmodel.experiment!.repetitions.toString(),
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
                      const SizedBox(
                        width: 50,
                      ),
                      Column(
                        children: [
                          Text(
                            viewmodel.experiment!.enzymes!.length.toString(),
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
                    ],
                  ),
                  if (_expandToSeeMoreVisible) ...[
                    const SizedBox(
                      height: 32,
                    ),
                    const Text(
                      "Toque para mais informações",
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ]
                ],
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: leadWithTreatments,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: leadWithEnzymes,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          onPressed: () => Navigator.pushNamed(
            context,
            RouteGenerator.experimentInsertData,
            arguments: viewmodel.experiment!,
          ),
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
    context.watch<ExperimentDetailedViewmodel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Detalhes do experimento",
          style: TextStyles.titleBoldBackground,
        ),
        actions: [
          if (viewmodel.state == StateEnum.success)
            IconButton(
              onPressed: () {
                experimentsViewmodel.deleteExperiment(viewmodel.experiment!.id);
                experimentsViewmodel.experiments
                    .removeWhere((exp) => exp.id == viewmodel.experiment!.id);
                experimentsViewmodel.notifyListeners();

                Navigator.pop(context);

                EZTSnackBar.clear(context);
                EZTSnackBar.show(
                  context,
                  '${viewmodel.experiment!.name} excluído!',
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildBody(
          MediaQuery.of(context).size.height,
        ),
      ),
    );
  }
}
