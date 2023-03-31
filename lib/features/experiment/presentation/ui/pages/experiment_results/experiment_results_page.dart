// 🐦 Flutter imports:
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/extensions/double_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../domain/entities/experiment_entity.dart';
import '../../../viewmodel/experiment_details_viewmodel.dart';
import '../../../viewmodel/experiment_results_viewmodel.dart';

class ExperimentResultsPage extends StatefulWidget {
  const ExperimentResultsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExperimentResultsPage> createState() => _ExperimentResultsPageState();
}

class _ExperimentResultsPageState extends State<ExperimentResultsPage> {
  late final ExperimentResultsViewmodel _experimentResultsViewmodel;
  late final ExperimentDetailsViewmodel _experimentDetailsViewmodel;
  late final ExperimentEntity _experiment;

  @override
  void initState() {
    super.initState();
    _experimentResultsViewmodel = GetIt.I.get<ExperimentResultsViewmodel>();
    _experimentDetailsViewmodel = GetIt.I.get<ExperimentDetailsViewmodel>();
    _experiment = _experimentDetailsViewmodel.experiment!;

    _experimentResultsViewmodel.fetch();

    if (mounted) {
      _experimentResultsViewmodel.addListener(
        () {
          if (mounted && _experimentResultsViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_experimentResultsViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  /* Widget _buildTitle(String title) {
    return InkWell(
      onTap: () {},
      // hoverColor: AppColors.primary,
      splashColor: AppColors.primary.withOpacity(0.5),
      highlightColor: AppColors.primary.withOpacity(0.1),
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   children: <Widget>[
            //     // Text(title),
            //     // Spacer(),
            //     // Text("Toque para expandir"),
            //   ],
            // ),
            // Text("Kursubersicht"),
            Row(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyles.informationExperimentStepTitle,
                ),
                const Spacer(),
                const Icon(PhosphorIcons.table, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  } */

  Widget _buildHeader(String title, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppSvgs.iconLogo,
            alignment: Alignment.center,
            width: 75,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                title,
                style: TextStyles.informationExperimentStepTitle
                    .copyWith(fontSize: 28),
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                message,
                style: TextStyles.informationExperimentStepMessage
                    .copyWith(fontSize: 20),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
        const SizedBox(height: 64),
      ],
    );
  }

  get _buildBody {
    if (_experimentResultsViewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(message: "Carregando resultados...");
    }

    final results = _experimentResultsViewmodel.experimentResult;

    return SafeArea(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 32),
                _buildHeader(
                  'Resultados',
                  'Experimento: ${_experiment.name}',
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: results!.enzymes.length,
                    shrinkWrap: true,
                    itemBuilder: (context, indexOfEnzymes) {
                      return ListTile(
                        title: ExpansionTile(
                          backgroundColor:
                              AppColors.materialTheme.shade100.withOpacity(0.3),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                results.enzymes[indexOfEnzymes].enzyme.name,
                                style:
                                    TextStyles.informationExperimentStepTitle,
                              ),
                              const Text(
                                'Enzima',
                              )
                            ],
                          ),
                          children: results.enzymes[indexOfEnzymes].treatments
                              .map(
                                (treatment) => ListTile(
                                  title: ExpansionTile(
                                    backgroundColor: AppColors.white,
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          treatment.treatment.name,
                                          style: TextStyles
                                              .informationExperimentStepTitle
                                              .copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const Text(
                                          'Tratamento',
                                        )
                                      ],
                                    ),
                                    children: [
                                      LayoutBuilder(builder:
                                          (BuildContext context,
                                              BoxConstraints constraints) {
                                        // print(constraints);
                                        // print(constraints.minHeight);
                                        // print(constraints.maxHeight);
                                        // print(constraints.biggest.);
                                        return ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                            height:
                                                max(100, constraints.maxWidth),
                                            width:
                                                max(600, constraints.maxWidth),
                                          ),
                                          child: DataTable2(
                                            columnSpacing: 12,
                                            // horizontalMargin: 12,
                                            minWidth: 1200,
                                            columns: const [
                                              DataColumn(
                                                label: Text('Amostra'),
                                                numeric: true,
                                                // size: ColumnSize.L,
                                              ),
                                              DataColumn(
                                                label: Text('Am. Branca'),
                                                numeric: true,
                                                tooltip: 'Amostra Branca',
                                              ),
                                              DataColumn(
                                                label: Text('Diferença'),
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                label: Text('Variável A'),
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                label: Text('Variável B'),
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                label: Text('Curva'),
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                label: Text('F. de Correção'),
                                                numeric: true,
                                                tooltip: 'Fator de Correção',
                                              ),
                                              DataColumn(
                                                label: Text('Tempo (h)'),
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                label: Text('Volume'),
                                                numeric: true,
                                              ),
                                              DataColumn(
                                                label: Text('Peso da Am.'),
                                                numeric: true,
                                                tooltip: 'Peso da Amostra',
                                              ),
                                              DataColumn(
                                                label: Text('Resultado'),
                                                numeric: true,
                                              ),
                                            ],
                                            rows: List<DataRow>.generate(
                                              treatment
                                                  .repetitionResults.length,
                                              (index) => DataRow(
                                                cells: [
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .sample
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .whiteSample
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .differenceBetweenSamples
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .variableA
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .variableB
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .curve
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .correctionFactor
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .time
                                                      .toString())),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .volume
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .weightSample
                                                      .formmatedNumber)),
                                                  DataCell(Text(treatment
                                                      .repetitionResults[index]
                                                      .result
                                                      .formmatedNumber)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _experimentResultsViewmodel,
      builder: (context, child) {
        return Scaffold(
          // appBar: AppBar(
          //   backgroundColor: AppColors.primary,
          //   title: Text(
          //     "Resultados do experimento",
          //     style: TextStyles.titleBoldBackground,
          //   ),
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _experimentResultsViewmodel.exportToExcel().then(
                    (flag) => flag
                        ? EZTSnackBar.show(
                            context,
                            'Arquivo salvo com sucesso!',
                            eztSnackBarType: EZTSnackBarType.success,
                          )
                        : EZTSnackBar.show(
                            context,
                            'Não foi possível salvar o arquivo, tente novamente.',
                            eztSnackBarType: EZTSnackBarType.error,
                          ),
                  );
            },
            // label: Text(
            //   "Compartilhar",
            //   style: TextStyles.buttonBoldBackground,
            // ),

            child: const Icon(
              PhosphorIcons.shareNetwork,
              size: 35,
              color: AppColors.white,
            ),
          ),
          body: _buildBody,
        );
      },
    );
  }
}
