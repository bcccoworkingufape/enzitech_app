// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../dto/create_experiment_dto.dart';
import '../../../viewmodel/create_experiment_viewmodel.dart';
import 'fragments/create_experiment_first_step.dart';
import 'fragments/create_experiment_fourth_step.dart';
import 'fragments/create_experiment_second_step.dart';
import 'fragments/create_experiment_third_step.dart';

class CreateExperimentPage extends StatefulWidget {
  const CreateExperimentPage({
    super.key,
  });

  @override
  State<CreateExperimentPage> createState() => _CreateExperimentPageState();
}

class _CreateExperimentPageState extends State<CreateExperimentPage> {
  late final CreateExperimentViewmodel _createExperimentViewmodel;

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
          } else if (_createExperimentViewmodel.state == StateEnum.success &&
              _createExperimentViewmodel.experiment != null) {
            if (mounted) {
              if (!mounted) return;
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.popAndPushNamed(
                  context,
                  Routing.experimentDetailed,
                  arguments: _createExperimentViewmodel.experiment,
                ).whenComplete(() {
                  _createExperimentViewmodel.setExperiment(null);
                  _createExperimentViewmodel.setTemporaryExperiment(
                    CreateExperimentDTO(),
                  );
                }).then((value) => EZTSnackBar.show(
                      context,
                      "Experimento criado com sucesso!",
                      eztSnackBarType: EZTSnackBarType.success,
                    ));
              });
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (_createExperimentViewmodel.alreadyPopped) {
          _createExperimentViewmodel.setAlreadyPopped(false);
          return;
        }
        _createExperimentViewmodel.onBack(mounted, context);
        return;
      },
      child: ListenableBuilder(
        listenable: _createExperimentViewmodel,
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
