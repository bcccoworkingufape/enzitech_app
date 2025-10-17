// 🎯 Dart imports:
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';

// 📦 Package imports:
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../shared/extensions/double_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../domain/entities/experiment_entity.dart';
import '../../../viewmodel/experiment_details_viewmodel.dart';
import '../../../viewmodel/experiment_results_viewmodel.dart';

class ExperimentResultsPage extends StatefulWidget {
  const ExperimentResultsPage({super.key});

  @override
  State<ExperimentResultsPage> createState() => _ExperimentResultsPageState();
}

class _ExperimentResultsPageState extends State<ExperimentResultsPage> {
  late final ExperimentResultsViewmodel _experimentResultsViewmodel;
  late final ExperimentDetailsViewmodel _experimentDetailsViewmodel;
  late final ExperimentEntity _experiment;
  late final AppLocalizations? l10n;

  @override
  void initState() {
    super.initState();
    _experimentResultsViewmodel = GetIt.I.get<ExperimentResultsViewmodel>();
    _experimentDetailsViewmodel = GetIt.I.get<ExperimentDetailsViewmodel>();
    _experiment = _experimentDetailsViewmodel.experiment!;

    _experimentResultsViewmodel.fetch();

    if (mounted) {
      _experimentResultsViewmodel.addListener(() {
        if (mounted && _experimentResultsViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(l10n, _experimentResultsViewmodel.failure!),
            duration:
                _experimentResultsViewmodel.failure! is UnableToSaveFailure
                ? const Duration(seconds: 15)
                : null,
            eztSnackBarType: EZTSnackBarType.error,
          ).then(
            (_) => Future.delayed(const Duration(seconds: 7), () {
              _experimentResultsViewmodel.setStateEnum(StateEnum.idle);
            }),
          );
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    l10n = AppLocalizations.of(context);
  }

  Widget _buildHeader(String title, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              context.isDarkMode ? AppImages.logoOnDark : AppImages.logoGreen,
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
                  style: TextStyles(
                    context,
                  ).informationExperimentStepTitle(fontSize: 28),
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  message,
                  style: TextStyles.informationExperimentStepMessage.copyWith(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }

  get _buildBody {
    if (_experimentResultsViewmodel.state == StateEnum.loading) {
      return EZTProgressIndicator(message: l10n?.loadingResults);
    }

    final results = _experimentResultsViewmodel.experimentResult;

    return SafeArea(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(
              l10n?.results ?? "",
              l10n?.experimentHeader(_experiment.name) ?? "",
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
                                  style: TextStyles(context)
                                      .informationExperimentStepTitle(
                                        fontSize: 28,
                                      ),
                                ),
                                Text(
                                  l10n?.enzymeTypeHeader(
                                    results.enzymes[indexOfEnzymes].enzyme.name,
                                    results
                                        .enzymes[indexOfEnzymes]
                                        .enzyme
                                        .formula,
                                  ) ?? "",
                                ),
                              ],
                            ),
                            children: results.enzymes[indexOfEnzymes].treatments
                                .map(
                                  (treatment) => ListTile(
                                    title: ExpansionTile(
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            treatment.treatment.name,
                                            style: TextStyles.bodyBold,
                                          ),
                                          Text(l10n?.treatmentLabel ?? ""),
                                        ],
                                      ),
                                      children: [
                                        LayoutBuilder(
                                          builder:
                                              (
                                                BuildContext context,
                                                BoxConstraints constraints,
                                              ) {
                                                double rowHeight =
                                                    (49.1 *
                                                            (treatment
                                                                    .repetitionResults
                                                                    .length +
                                                                1))
                                                        .toDouble();

                                                return ConstrainedBox(
                                                  constraints:
                                                      BoxConstraints.tightFor(
                                                        height: rowHeight,
                                                        width: max(
                                                          600,
                                                          constraints.maxWidth,
                                                        ),
                                                      ),
                                                  child: ScrollConfiguration(
                                                    behavior: MyBehavior(),
                                                    child: GlowingOverscrollIndicator(
                                                      axisDirection:
                                                          AxisDirection.down,
                                                      color: context
                                                          .getApplyedColorScheme
                                                          .primary
                                                          .withOpacity(0.3),
                                                      child: DataTable2(
                                                        columnSpacing: 12,
                                                        minWidth: 1200,
                                                        columns: [
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnId ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnSample ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnWhiteSampleShort ?? "",
                                                            ),
                                                            numeric: true,
                                                            tooltip: l10n
                                                                ?.columnWhiteSampleTooltip ?? "",
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnDifference ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.variableA ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.variableB ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnCurve ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnCorrectionFactorShort ?? "",
                                                            ),
                                                            numeric: true,
                                                            tooltip: l10n
                                                                ?.correctionFactor,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.timeHours ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnVolume ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnSampleWeightShort ?? "",
                                                            ),
                                                            numeric: true,
                                                            tooltip: l10n
                                                                ?.columnSampleWeightTooltip,
                                                          ),
                                                          DataColumn(
                                                            label: Text(
                                                              l10n?.columnResult ?? "",
                                                            ),
                                                            numeric: true,
                                                          ),
                                                        ],
                                                        rows: List<DataRow2>.generate(
                                                          treatment
                                                              .repetitionResults
                                                              .length,
                                                          (
                                                            index,
                                                          ) => DataRow2.byIndex(
                                                            index: index,
                                                            color: index.isEven
                                                                ? MaterialStateProperty.all(
                                                                    context
                                                                        .getApplyedColorScheme
                                                                        .surfaceVariant,
                                                                  )
                                                                : null,
                                                            cells: [
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .repetitionId,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .sample
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .whiteSample
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .differenceBetweenSamples
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .variableA
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .variableB
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .curve
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .correctionFactor
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .time
                                                                      .toString(),
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .volume
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .weightSample
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                              DataCell(
                                                                Text(
                                                                  treatment
                                                                      .repetitionResults[index]
                                                                      .result
                                                                      .formmatedNumber,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                        ),
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
                      text: l10n?.backButton ?? "",
                      eztButtonType: EZTButtonType.regular,
                      onPressed: () {
                        Navigator.pop(context);
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

  get _rotateFloatingActionButtonBuilder => RotateFloatingActionButtonBuilder(
    child: Icon(PhosphorIcons.dotsThreeVertical()),
    fabSize: ExpandableFabSize.regular,
    backgroundColor: context.getApplyedColorScheme.primary,
    foregroundColor: context.getApplyedColorScheme.onPrimary,
    shape: const CircleBorder(),
  );

  Map<String, String> _buildExcelTranslations() {
    return {
      'excel_treatmentLabel': l10n?.excel_treatmentLabel ?? "",
      'excel_col_id': l10n?.excel_col_id ?? "",
      'excel_col_sampleAbsorbance': l10n?.excel_col_sampleAbsorbance ?? "",
      'excel_col_whiteSampleAbsorbance': l10n?.excel_col_whiteSampleAbsorbance ?? "",
      'excel_col_difference': l10n?.excel_col_difference ?? "",
      'excel_col_variableA': l10n?.excel_col_variableA ?? "",
      'excel_col_variableB': l10n?.excel_col_variableB ?? "",
      'excel_col_curveCalculation': l10n?.excel_col_curveCalculation ?? "",
      'excel_col_correctionFactor': l10n?.excel_col_correctionFactor ?? "",
      'excel_col_time': l10n?.excel_col_time ?? "",
      'excel_col_volume': l10n?.excel_col_volume ?? "",
      'excel_col_sampleWeight': l10n?.excel_col_sampleWeight ?? "",
      'excel_col_result': l10n?.excel_col_result ?? "",
      'excel_footer_developedBy': l10n?.excel_footer_developedBy ?? "",
      'excel_footer_learnMore': l10n?.excel_footer_learnMore ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {

    return ListenableBuilder(
      listenable: _experimentResultsViewmodel,
      builder: (context, child) {
        return Scaffold(
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton:
              _experimentResultsViewmodel.state == StateEnum.loading ||
                  _experimentResultsViewmodel.state == StateEnum.error
              ? null
              : ExpandableFab(
                  type: ExpandableFabType.up,
                  openButtonBuilder: _rotateFloatingActionButtonBuilder,
                  closeButtonBuilder: _rotateFloatingActionButtonBuilder,
                  children: [
                    FloatingActionButton.small(
                      shape: const CircleBorder(),
                      backgroundColor: context.getApplyedColorScheme.primary,
                      foregroundColor: context.getApplyedColorScheme.onPrimary,
                      heroTag: null,
                      child: Icon(PhosphorIcons.share()),
                      onPressed: () {
                        final translations =
                            _buildExcelTranslations();
                        final translatedFilename = l10n
                            ?.shareExperimentResultsFilename(
                              _experimentDetailsViewmodel.experiment!.name,
                            );

                        _experimentResultsViewmodel
                            .shareFile(translations, translatedFilename ?? "")
                            .then((success) {
                              if (!success) {
                                EZTSnackBar.show(
                                  context,
                                  l10n?.shareFileError ?? "",
                                  eztSnackBarType: EZTSnackBarType.error,
                                );
                              }
                            });
                      },
                    ),
                    FloatingActionButton.small(
                      shape: const CircleBorder(),
                      backgroundColor: context.getApplyedColorScheme.primary,
                      foregroundColor: context.getApplyedColorScheme.onPrimary,
                      heroTag: null,
                      child: Icon(
                        PhosphorIcons.downloadSimple(),
                      ),
                      onPressed: () {
                        final translations = _buildExcelTranslations();

                        _experimentResultsViewmodel
                            .openDialogToUserSaveFile(translations)
                            .then(
                              (flag) => flag
                              ? EZTSnackBar.show(
                            context,
                            l10n?.spreadsheetSavedSuccess ?? "",
                            eztSnackBarType: EZTSnackBarType.success,
                          )
                              : _experimentResultsViewmodel.failure
                          is! UnableToSaveFailure
                              ? EZTSnackBar.show(
                            context,
                            l10n?.spreadsheetSaveError ?? "",
                            eztSnackBarType:
                            EZTSnackBarType.error,
                          ) : null,
                        );
                      },
                    ),
                  ],
                ),
          body: _buildBody,
        );
      },
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
