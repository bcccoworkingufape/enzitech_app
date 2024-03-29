// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/routing/routing.dart';
import '../../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../../shared/extensions/num_extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class CalculateExperimentThirdStepPage extends StatefulWidget {
  const CalculateExperimentThirdStepPage({
    super.key,
  });

  @override
  State<CalculateExperimentThirdStepPage> createState() =>
      _CalculateExperimentThirdStepPageState();
}

class _CalculateExperimentThirdStepPageState
    extends State<CalculateExperimentThirdStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;
  bool loadingAbsNumberFartherFromAverage = false;
  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
    _calculateExperimentViewmodel.getAbsNumberFartherFromAverage();
    _calculateExperimentViewmodel.calculateListOfNumbersFartherFromAverage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _calculateExperimentViewmodel.getAbsNumberFartherFromAverage();
    _calculateExperimentViewmodel.calculateListOfNumbersFartherFromAverage();
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnSecondStep,
          text: 'Salvar e sair',
          loading: _calculateExperimentViewmodel.state == StateEnum.loading,
          onPressed: () async {
            await _calculateExperimentViewmodel
                .saveResult()
                .whenComplete(() => Navigator.popUntil(
                      context,
                      ModalRoute.withName(Routing.experimentDetailed),
                    ));
          },
        ),
        const SizedBox(height: 16),
        EZTButton(
          text: 'Recalcular',
          eztButtonType: EZTButtonType.outline,
          onPressed: () {
            _calculateExperimentViewmodel.onBack(mounted, context);
          },
        ),
      ],
    );
  }

  TableRow _buildTableRow(num result, int iteration) {
    return TableRow(
      decoration: const UnderlineTabIndicator(borderSide: BorderSide()),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            "Repetição ${iteration + 1}:",
            style: TextStyles.bodyBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            result.formmatedNumber,
            style: TextStyles.bodyBold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Visibility(
            visible: _calculateExperimentViewmodel
                .listOfNumberDifferencesDTO[iteration]!.isFarther!,
            replacement: Icon(
              PhosphorIcons.thumbsUp(),
              color: context.getApplyedColorScheme.surfaceTint,
            ),
            child: GestureDetector(
              onTap: () {
                EZTSnackBar.clear(context);
                EZTSnackBar.show(
                  context,
                  'Esta repetição está discrepante!\n\nO valor dela difere acima de 25% da média de todos as repetições.\n\nCaso queira mudar, basta pressionar "Recalcular".',
                  textStyle: TextStyles(context).titleMinBoldBackground(),
                  centerTitle: true,
                  eztSnackBarType: EZTSnackBarType.error,
                );
              },
              child: Icon(
                PhosphorIcons.warningCircle(PhosphorIconsStyle.bold),
                color: context.getApplyedColorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TableRow> _buildListOfRows(List<num> results) {
    List<TableRow> listOfTableRows = [];
    for (var i = 0; i < results.length; i++) {
      listOfTableRows.add(_buildTableRow(results[i], i));
    }

    return listOfTableRows;
  }

  List<TableRow> _buildAverageRow(num number) {
    return [
      const TableRow(
        children: [
          SizedBox(height: 16),
          SizedBox(height: 16),
          SizedBox(height: 16),
        ],
      ),
      TableRow(
        children: [
          Text(
            "Média:",
            style: TextStyles.bodyBold,
          ),
          Text(
            number.formmatedNumber,
            style: TextStyles.bodyBold,
          ),
          Container(),
        ],
      ),
    ];
  }

  List<TableRow> _buildTitleRow() {
    return [
      TableRow(
        children: [
          Text(
            "REPETIÇÃO",
            style: TextStyles.bodyBold,
          ),
          Text(
            "RESULTADO",
            style: TextStyles.bodyBold,
          ),
          Text(
            "STATUS",
            style: TextStyles.bodyBold,
          ),
        ],
      ),
      const TableRow(
        children: [
          SizedBox(height: 8),
          SizedBox(height: 8),
          SizedBox(height: 8),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _calculateExperimentViewmodel,
      builder: (context, child) {
        return CalculateExperimentFragmentTemplate(
          titleOfStepIndicator: "Inserir dados no experimento",
          messageOfStepIndicator: "Etapa 3 de 3 - Resultados",
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (_calculateExperimentViewmodel.numberDifferencesDTO ==
                    null) {
                  return const Center(
                    child: EZTProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        _calculateExperimentViewmodel
                            .temporaryChoosedExperimentCombination.enzyme!.name,
                        textAlign: TextAlign.center,
                        style: TextStyles(context).titleBoldBackground(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                        ),
                      ),
                      const Divider(),
                      Text(
                        _calculateExperimentViewmodel
                            .temporaryChoosedExperimentCombination
                            .treatment!
                            .name,
                        textAlign: TextAlign.center,
                        style: TextStyles(context).titleBoldBackground(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Card(
                        margin: const EdgeInsets.all(16),
                        color: context.getApplyedColorScheme.background,
                        shadowColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _calculateExperimentViewmodel
                                .temporaryChoosedExperimentCombination
                                .enzyme!
                                .formula,
                            textAlign: TextAlign.center,
                            style: TextStyles(context).titleBoldBackground(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Table(
                        columnWidths: const <int, TableColumnWidth>{
                          0: IntrinsicColumnWidth(flex: 2),
                          1: IntrinsicColumnWidth(flex: 3),
                          2: IntrinsicColumnWidth(flex: 1),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          ..._buildTitleRow(),
                          ..._buildListOfRows(_calculateExperimentViewmodel
                              .experimentCalculationEntity!.results),
                          ..._buildAverageRow(_calculateExperimentViewmodel
                              .experimentCalculationEntity!.average)
                        ],
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      _buttons,
                    ],
                  );
                }
              },
              //TODO: verify this update on FutureBuilder
              future: null,
            ),
          ),
        );
      },
    );
  }
}
