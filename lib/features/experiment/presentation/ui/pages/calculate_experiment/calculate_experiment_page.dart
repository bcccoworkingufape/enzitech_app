import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../domain/entities/experiment_entity.dart';
import '../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../../../viewmodel/experiments_viewmodel.dart';
import 'fragments/calculate_experiment_first_step.dart';
import 'fragments/calculate_experiment_second_step.dart';
import 'fragments/calculate_experiment_third_step.dart';

class CalculateExperimentPage extends StatefulWidget {
  const CalculateExperimentPage({
    Key? key,
    required this.experiment,
  }) : super(key: key);

  final ExperimentEntity experiment;

  @override
  State<CalculateExperimentPage> createState() =>
      _CalculateExperimentPageState();
}

class _CalculateExperimentPageState extends State<CalculateExperimentPage> {
  late final CalculateExperimentViewmodel _calculateExperimentViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool _ageHasError = false;
  bool _genderHasError = false;

  @override
  void initState() {
    super.initState();
    _calculateExperimentViewmodel = GetIt.I.get<CalculateExperimentViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();

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

  /* void onBack({int? page}) {
    if (mounted) {
      if (page != null) {
        _calculateExperimentViewmodel.pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      } else {
        {
          if (_calculateExperimentViewmodel.pageController.page! > 0) {
            _calculateExperimentViewmodel.pageController.animateToPage(
              _calculateExperimentViewmodel.pageController.page!.toInt() - 1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          } else {
            _calculateExperimentViewmodel.setChoosedEnzymeAndTreatment(
              {
                "enzyme": null,
                "process": null,
                "experimentData": [],
              },
            );
            Navigator.pop(context);
          }
        }
      }
    }
  } */

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _calculateExperimentViewmodel.onBack(mounted, context);

        return _calculateExperimentViewmodel.pageController.page! > 0
            ? false
            : true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        /* appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            "Inserir dados no experimento",
            style: TextStyles.titleBoldBackground,
          ),
        ), */
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
