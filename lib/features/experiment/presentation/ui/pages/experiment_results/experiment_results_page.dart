// 🐦 Flutter imports:
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
              duration:
                  _experimentResultsViewmodel.failure! is UnableToSaveFailure
                      ? const Duration(seconds: 15)
                      : null,
              eztSnackBarType: EZTSnackBarType.error,
            ).then((_) => Future.delayed(const Duration(seconds: 7), () {
                  _experimentResultsViewmodel.setStateEnum(StateEnum.idle);
                }));
          }
        },
      );
    }
  }

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
          ScrollConfiguration(
            behavior: MyBehavior(),
            child: SliverFillRemaining(
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.transparent,
                            initiallyExpanded: true,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  results.enzymes[indexOfEnzymes].enzyme.name,
                                  style:
                                      TextStyles.informationExperimentStepTitle,
                                ),
                                Text(
                                  'Tipo: ${results.enzymes[indexOfEnzymes].enzyme.name} (${results.enzymes[indexOfEnzymes].enzyme.formula})',
                                )
                              ],
                            ),
                            children: results.enzymes[indexOfEnzymes].treatments
                                .map(
                                  (treatment) => ListTile(
                                    title: ExpansionTile(
                                      // backgroundColor: AppColors
                                      //     .materialTheme.shade100
                                      //     .withOpacity(0.1),  //TODO: COLOR-FIX
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
                                          const borderSideOfTable = BorderSide(
                                            width: 0.5,
                                            strokeAlign: 0,
                                            color: AppColors.primary,
                                          );

                                          double rowHeight = (49.1 *
                                                  (treatment.repetitionResults
                                                          .length +
                                                      1))
                                              .toDouble();

                                          return ConstrainedBox(
                                            constraints:
                                                BoxConstraints.tightFor(
                                              height: rowHeight,
                                              width: max(
                                                  600, constraints.maxWidth),
                                            ),
                                            child: ScrollConfiguration(
                                              behavior: const ScrollBehavior(),
                                              child: GlowingOverscrollIndicator(
                                                axisDirection:
                                                    AxisDirection.down,
                                                color: AppColors.primary
                                                    .withOpacity(0.3),
                                                child: DataTable2(
                                                  columnSpacing: 12,
                                                  // horizontalMargin: 12,
                                                  minWidth: 1200,
                                                  border: const TableBorder(
                                                    verticalInside:
                                                        borderSideOfTable,
                                                    top: borderSideOfTable,
                                                    bottom: borderSideOfTable,
                                                    left: borderSideOfTable,
                                                    right: borderSideOfTable,
                                                  ),
                                                  columns: const [
                                                    DataColumn(
                                                      label: Text('ID'),
                                                      numeric: true,
                                                      // size: ColumnSize.L,
                                                    ),
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
                                                      label: Text(
                                                          'F. de Correção'),
                                                      numeric: true,
                                                      tooltip:
                                                          'Fator de Correção',
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
                                                      label:
                                                          Text('Peso da Am.'),
                                                      numeric: true,
                                                      tooltip:
                                                          'Peso da Amostra',
                                                    ),
                                                    DataColumn(
                                                      label: Text('Resultado'),
                                                      numeric: true,
                                                    ),
                                                  ],
                                                  rows: List<DataRow2>.generate(
                                                    treatment.repetitionResults
                                                        .length,
                                                    (index) => DataRow2.byIndex(
                                                      index: index,
                                                      color: index.isEven
                                                          ? MaterialStateProperty
                                                              .all(Colors.white
                                                                  // AppColors.white,
                                                                  )
                                                          : null,
                                                      cells: [
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .repetitionId)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .sample
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .whiteSample
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .differenceBetweenSamples
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .variableA
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .variableB
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .curve
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .correctionFactor
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .time
                                                            .toString())),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .volume
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .weightSample
                                                            .formmatedNumber)),
                                                        DataCell(Text(treatment
                                                            .repetitionResults[
                                                                index]
                                                            .result
                                                            .formmatedNumber)),
                                                      ],
                                                    ),
                                                  ),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      MediaQuery.of(context).size.width * 0.2125,
                      16,
                    ),
                    child: EZTButton(
                      text: 'Voltar',
                      eztButtonType: EZTButtonType.regular,
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),
                  ),
                ],
              ),
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
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: _experimentResultsViewmodel.state ==
                      StateEnum.loading ||
                  _experimentResultsViewmodel.state == StateEnum.error
              ? null
              : ExpandableFab(
                  distance: 72,
                  type: ExpandableFabType.up,
                  children: [
                    FloatingActionButton.small(
                      heroTag: null,
                      child: Icon(
                        PhosphorIcons.shareNetwork(),
                        // color: AppColors.white, //TODO: COLOR-FIX
                      ),
                      onPressed: () {
                        _experimentResultsViewmodel.shareResult().then((flag) {
                          flag
                              ? null
                              : EZTSnackBar.show(
                                  context,
                                  'Não foi possível compartilhar o arquivo, tente novamente.',
                                  eztSnackBarType: EZTSnackBarType.error,
                                ).whenComplete(() => _experimentResultsViewmodel
                                  .setStateEnum(StateEnum.idle));
                        });
                      },
                    ),
                    FloatingActionButton.small(
                      heroTag: null,
                      child: Icon(
                        PhosphorIcons.download(),
                        // color: AppColors.white, //TODO: COLOR-FIX
                      ),
                      onPressed: () {
                        _experimentResultsViewmodel.exportToExcel().then(
                              (flag) => flag
                                  ? EZTSnackBar.show(
                                      context,
                                      'Arquivo salvo em ${_experimentResultsViewmodel.savedPath}',
                                      eztSnackBarType: EZTSnackBarType.success,
                                    )
                                  : _experimentResultsViewmodel.failure
                                          is! UnableToSaveFailure
                                      ? EZTSnackBar.show(
                                          context,
                                          'Não foi possível salvar o arquivo, tente novamente.',
                                          eztSnackBarType:
                                              EZTSnackBarType.error,
                                        )
                                      : null,
                            );
                      },
                    ),
                  ],
                ),
          /* floatingActionButton: FloatingActionButton(
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
          ), */
          body: _buildBody,
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
