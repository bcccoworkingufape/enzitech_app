import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../viewmodel/create_experiment_viewmodel.dart';
import 'fragments/create_experiment_first_step.dart';
import 'fragments/create_experiment_fourth_step.dart';
import 'fragments/create_experiment_second_step.dart';
import 'fragments/create_experiment_third_step.dart';

class CreateExperimentPage extends StatefulWidget {
  const CreateExperimentPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateExperimentPage> createState() => _CreateExperimentPageState();
}

class _CreateExperimentPageState extends State<CreateExperimentPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;

  // bool _expandToSeeMoreVisible = true;

  @override
  void initState() {
    super.initState();
    _createExperimentViewmodel = GetIt.I.get<CreateExperimentViewmodel>();

    if (mounted) {
      _createExperimentViewmodel.addListener(
        () {
          if (mounted && _createExperimentViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_createExperimentViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _createExperimentViewmodel.onBack(mounted, context);
        return _createExperimentViewmodel.pageController.page! > 0
            ? false
            : true;
      },
      child: AnimatedBuilder(
        animation: _createExperimentViewmodel,
        builder: (context, child) {
          return Scaffold(
            body: Form(
              key: _createExperimentViewmodel.formKey,
              child: PageView(
                controller: _createExperimentViewmodel.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  CreateExperimentFirstStepPage(),
                  CreateExperimentSecondStepPage(),
                  CreateExperimentThirdStepPage(),
                  CreateExperimentFourthStepPage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
