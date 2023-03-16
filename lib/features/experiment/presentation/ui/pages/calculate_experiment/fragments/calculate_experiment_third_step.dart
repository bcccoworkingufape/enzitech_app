import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../../../../viewmodel/experiments_viewmodel.dart';

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
  late final ExperimentsViewmodel _experimentsViewmodel;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();

    /* if (mounted) {
      _calculateExperimentViewmodel.addListener(
        () {
          if (mounted &&
              _calculateExperimentViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_calculateExperimentViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    } */
  }
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
