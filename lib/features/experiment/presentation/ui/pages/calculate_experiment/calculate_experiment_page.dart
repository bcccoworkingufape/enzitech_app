// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../domain/entities/experiment_entity.dart';
import '../../../viewmodel/calculate_experiment_viewmodel.dart';
import 'fragments/calculate_experiment_first_step.dart';
import 'fragments/calculate_experiment_second_step.dart';
import 'fragments/calculate_experiment_third_step.dart';

class CalculateExperimentPage extends StatefulWidget {
  const CalculateExperimentPage({
    super.key,
    required this.experiment,
  });

  final ExperimentEntity experiment;

  @override
  State<CalculateExperimentPage> createState() =>
      _CalculateExperimentPageState();
}

class _CalculateExperimentPageState extends State<CalculateExperimentPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();

    _calculateExperimentViewmodel.setExperiment(widget.experiment);

    if (mounted) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Verify PopScope Migration
    return  PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (_calculateExperimentViewmodel.alreadyPopped) {
          _calculateExperimentViewmodel.setAlreadyPopped(false);
          return;
        }
        _calculateExperimentViewmodel.onBack(mounted, context);
        return;
      },
      child:Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Form(
            key: _calculateExperimentViewmodel.formKey,
            child: PageView(
              controller: _calculateExperimentViewmodel.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                CalculateExperimentFirstStepPage(),
                CalculateExperimentSecondStepPage(),
                CalculateExperimentThirdStepPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
