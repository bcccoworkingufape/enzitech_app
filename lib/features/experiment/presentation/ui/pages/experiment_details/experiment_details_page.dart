// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../../../main/presentation/viewmodel/home_viewmodel.dart';
import '../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../../../viewmodel/experiment_details_viewmodel.dart';
import '../../../viewmodel/experiments_viewmodel.dart';
import '../../widgets/experiment_exclusion_dialog.dart';

class ExperimentDetailsPage extends StatefulWidget {
  const ExperimentDetailsPage({
    super.key,
    // required this.resumedExperiment,
  });

  // final ExperimentEntity resumedExperiment;

  @override
  State<ExperimentDetailsPage> createState() => _ExperimentDetailsPageState();
}

class _ExperimentDetailsPageState extends State<ExperimentDetailsPage> {
  late final ExperimentDetailsViewmodel _experimentDetailsViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final HomeViewmodel _homeViewmodel;

  bool _expandToSeeMoreVisible = true;

  @override
  void initState() {
    super.initState();
    _experimentDetailsViewmodel = GetIt.I.get<ExperimentDetailsViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();
    // _progress = widget.resumedExperiment.progress;

    if (mounted) {
      _experimentDetailsViewmodel.addListener(
        () {
          if (mounted && _experimentDetailsViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_experimentDetailsViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }

    // _experimentDetailsViewmodel
    //     .getExperimentDetails(widget.resumedExperiment.id)
    //     .whenComplete(
    //         () => _progress = _experimentDetailsViewmodel.experiment!.progress);
  }

  get leadWithEnzymes {
    if (_experimentDetailsViewmodel.experiment!.enzymes != null) {
      if (_experimentDetailsViewmodel.experiment!.enzymes!.isNotEmpty) {
        return _experimentDetailsViewmodel.experiment!.enzymes!
            .map((element) => Text(element.name))
            .toList();
      }
    }
    return const [Text("Sem dados!")];
  }

  get leadWithTreatments {
    if (_experimentDetailsViewmodel.experiment!.treatments != null) {
      if (_experimentDetailsViewmodel.experiment!.treatments!.isNotEmpty) {
        return _experimentDetailsViewmodel.experiment!.treatments!
            .map((element) => Text(element.name))
            .toList();
      }
    }
    return const [Text("Sem dados!")];
  }

  Widget _buildBody(double height) {
    if (_experimentDetailsViewmodel.state == StateEnum.error) {
      return EZTError(
        message:
            'Erro ao carregar o experimento "${_experimentDetailsViewmodel.experiment!.name}"',
      );
    }

    if (_experimentDetailsViewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(
        message: "Carregando experimento...",
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10.0,
            percent: _experimentDetailsViewmodel.experiment!.progress,
            center: Text(
              Toolkit.doubleToPercentual(
                  _experimentDetailsViewmodel.experiment!.progress),
              style: TextStyles.titleBoldHeading,
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.4),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            _experimentDetailsViewmodel.experiment!.description,
            style: TextStyles.detailRegular,
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(
              // color: AppColors.grey, //TODO: COLOR-FIX
              ),
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
                              _experimentDetailsViewmodel
                                  .experiment!.treatments!.length
                                  .toString(),
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
                              _experimentDetailsViewmodel
                                  .experiment!.repetitions
                                  .toString(),
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
                              _experimentDetailsViewmodel
                                  .experiment!.enzymes!.length
                                  .toString(),
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
          const Divider(
              // color: AppColors.grey, //TODO: COLOR-FIX
              ),
          const SizedBox(
            height: 20,
          ),
          EZTButton(
            text: 'Cálculo enzimático',
            eztButtonType: EZTButtonType.checkout,
            enabled: _experimentDetailsViewmodel.experiment!.progress != 1,
            icon: Icon(
              PhosphorIcons.function(),
              // color: AppColors.white, //TODO: COLOR-FIX
              size: 30,
            ),
            onPressed: () {
              GetIt.I.get<CalculateExperimentViewmodel>
                  .call()
                  .clearTemporaryInfos();
              Navigator.pushNamed(
                context,
                Routing.calculateExperiment,
                arguments: _experimentDetailsViewmodel.experiment!,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          EZTButton(
            text: 'Resultados',
            enabled: _experimentDetailsViewmodel.experiment!.progress != 0,
            eztButtonType: EZTButtonType.checkout,
            icon: Icon(
              PhosphorIcons.fileText(),
              // color: AppColors.white, //TODO: COLOR-FIX
              size: 30,
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              Routing.experimentResults,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: _experimentDetailsViewmodel,
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              title: Text(
                "Detalhes do experimento",
                style: TextStyles.titleBoldBackground,
              ),
              actions: [
                if (_experimentDetailsViewmodel.state == StateEnum.success)
                  IconButton(
                    onPressed: () async {
                      var shouldDelete = _homeViewmodel
                              .accountViewmodel.enableExcludeConfirmation!
                          ? await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return const ExperimentExclusionDialog();
                              },
                            )
                          : null;

                      if (shouldDelete != null) {
                        if (!shouldDelete) return;
                      }

                      _experimentsViewmodel.deleteExperiment(
                          _experimentDetailsViewmodel.experiment!.id);
                      _experimentsViewmodel.experiments.removeWhere((exp) =>
                          exp.id == _experimentDetailsViewmodel.experiment!.id);
                      _experimentsViewmodel.notifyListeners();

                      if (mounted) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          Navigator.pop(context);

                          EZTSnackBar.clear(context);
                          EZTSnackBar.show(
                            context,
                            '${_experimentDetailsViewmodel.experiment!.name} excluído!',
                            eztSnackBarType: EZTSnackBarType.error,
                          );
                        });
                      }
                    },
                    icon: Icon(
                      PhosphorIcons.trash(),
                      // color: AppColors.white, //TODO: COLOR-FIX
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
        });
  }
}
