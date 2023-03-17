import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/routing/routing.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../calculate_experiment_fragment_template.dart';

class NumberDifferences {
  final double differenceOfFartherNumber;
  final double fartherNumber;

  NumberDifferences({
    required this.differenceOfFartherNumber,
    required this.fartherNumber,
  });
}

class CalculateExperimentThirdStepPage extends StatefulWidget {
  const CalculateExperimentThirdStepPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CalculateExperimentThirdStepPage> createState() =>
      _CalculateExperimentThirdStepPageState();
}

class _CalculateExperimentThirdStepPageState
    extends State<CalculateExperimentThirdStepPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;
  late NumberDifferences numberDifferences;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();

    _getAbsNumberFartherFromAverage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAbsNumberFartherFromAverage();
  }

  Widget get _buttons {
    return Column(
      children: [
        EZTButton(
          enabled: _calculateExperimentViewmodel.enableNextButtonOnSecondStep,
          text: 'Salvar e sair',
          loading: _calculateExperimentViewmodel.state == StateEnum.loading,
          onPressed: () async {
            Navigator.popUntil(
              context,
              ModalRoute.withName(Routing.experimentDetailed),
            );
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

  _getAbsNumberFartherFromAverage() {
    /* double differenceOfFartherNumber = (_calculateExperimentViewmodel
                .experimentCalculationEntity!.results.first -
            _calculateExperimentViewmodel.experimentCalculationEntity!.average)
        .abs();

    double fartherNumber = _calculateExperimentViewmodel
        .experimentCalculationEntity!.results.first; */
    final average =
        _calculateExperimentViewmodel.experimentCalculationEntity!.average;

    final results =
        _calculateExperimentViewmodel.experimentCalculationEntity!.results;

    double differenceOfFartherNumber =
        percentOfDifference(average, results.first);

    double fartherNumber = _calculateExperimentViewmodel
        .experimentCalculationEntity!.results.first;

    for (var number in results) {
      var diff = percentOfDifference(average, number);
      if (diff > differenceOfFartherNumber) {
        differenceOfFartherNumber = diff;
        fartherNumber = number;
      }
    }

    setState(() {
      numberDifferences = NumberDifferences(
          differenceOfFartherNumber: differenceOfFartherNumber,
          fartherNumber: fartherNumber);
    });

    // return fartherNumber;
  }

  double percentOfDifference(num num1, num num2) =>
      (((num2 - num1) / num1) * 100).abs();

  Widget _buildResult(double result, int iteration) {
    TextStyle textStyleOk = TextStyles.bodyBold.copyWith(
      fontSize: 24,
    );

    TextStyle textStyleError = textStyleOk.copyWith(
      color: AppColors.danger,
    );

    NumberFormat numberFormat = NumberFormat.decimalPattern('pt_BR');

    return Center(
      child: Visibility(
        visible: numberDifferences.fartherNumber == result,
        replacement: Text(
          'Repetição $iteration: ${numberFormat.format(result)}',
          style: textStyleOk,
        ),
        child: Text(
          'Repetição $iteration: ${numberFormat.format(result)}',
          style: numberDifferences.differenceOfFartherNumber > 25
              ? textStyleError
              : textStyleOk,
        ),
      ),
    );
  }

  Widget _buildAverage(double average) {
    NumberFormat numberFormat = NumberFormat.decimalPattern('pt_BR');

    return Center(
      child: Text(
        'Média: ${numberFormat.format(average)}',
        style: TextStyles.bodyBold.copyWith(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _calculateExperimentViewmodel,
        builder: (context, child) {
          return CalculateExperimentFragmentTemplate(
            titleOfStepIndicator: "Inserir dados no experimento",
            messageOfStepIndicator: "Etapa 3 de 3 - Resultados",
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: FutureBuilder(builder:
                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    /* SingleChildScrollView(
                        child: ,
                      ), */
                    Text(
                      _calculateExperimentViewmodel
                          .temporaryChoosedExperimentCombination.treatmentName!,
                      textAlign: TextAlign.center,
                      style: TextStyles.titleBoldBackground.copyWith(
                        color: AppColors.greySweet,
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                      ),
                    ),
                    const Divider(),
                    Text(
                      _calculateExperimentViewmodel
                          .temporaryChoosedExperimentCombination.enzymeName!,
                      textAlign: TextAlign.center,
                      style: TextStyles.titleBoldBackground.copyWith(
                        color: AppColors.greySweet,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Card(
                      margin: EdgeInsets.all(16),
                      color: AppColors.primary.withAlpha(100),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'p-ntrof.(mg PNP g-1 de solo h1)',
                          textAlign: TextAlign.center,
                          style: TextStyles.titleBoldBackground.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                      itemCount: _calculateExperimentViewmodel
                          .experimentCalculationEntity!.results.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: _buildResult(
                              _calculateExperimentViewmodel
                                  .experimentCalculationEntity!.results[index],
                              index + 1),
                        );
                      },
                    ),
                    _buildAverage(_calculateExperimentViewmodel
                        .experimentCalculationEntity!.average),
                    const SizedBox(
                      height: 64,
                    ),
                    _buttons,
                  ],
                );
              }),
            ),
          );
        });
  }
}
