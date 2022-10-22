// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/fragments/create_experiment_first_step.dart';
import 'package:enzitech_app/src/features/create_experiment/fragments/create_experiment_fourth_step.dart';
import 'package:enzitech_app/src/features/create_experiment/fragments/create_experiment_second_step.dart';
import 'package:enzitech_app/src/features/create_experiment/fragments/create_experiment_third_step.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';
import 'package:enzitech_app/src/shared/models_/experiment_request_model.dart';
import 'package:enzitech_app/src/shared/utilities/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';

class CreateExperimentPage extends StatefulWidget {
  const CreateExperimentPage({Key? key}) : super(key: key);

  @override
  State<CreateExperimentPage> createState() => _CreateExperimentPageState();
}

class _CreateExperimentPageState extends State<CreateExperimentPage> {
  late final CreateExperimentController controller;
  late final ExperimentsController experimentsController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();
    experimentsController = context.read<ExperimentsController>();

    if (mounted) {
      controller.addListener(() {
        if (mounted && controller.state == CreateExperimentState.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(
              controller.failure!,
              enableStatusCode: true,
              overrideDefaultMessage: true,
            ),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (controller.state == CreateExperimentState.success &&
            controller.experimentCreated) {
          if (mounted) {
            controller.experimentCreated = false;
            controller.setExperimentRequestModel(
              ExperimentRequestModel(
                name: "",
                description: "",
                repetitions: 0,
                processes: [],
                experimentsEnzymes: [],
              ),
            );

            // reload the experiments list
            experimentsController.loadExperiments(1);

            EZTSnackBar.show(
              context,
              "Experimento criado com sucesso!",
              eztSnackBarType: EZTSnackBarType.success,
            );

            if (!mounted) return;
            Navigator.popAndPushNamed(
              context,
              RouteGenerator.experimentDetailed,
              arguments: controller.experimentModel,
            );

            controller.setExperimentModel(null);
          }
        }
      });
    }
  }

  void onBack() {
    if (mounted) {
      controller.experimentCreated = false;
      controller.setExperimentRequestModel(
        ExperimentRequestModel(
          name: "",
          description: "",
          repetitions: 0,
          processes: [],
          experimentsEnzymes: [],
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CreateExperimentFirstStepPage(
                callback: onBack,
                formKey: _formKey,
              ),
              CreateExperimentSecondStepPage(
                formKey: _formKey,
              ),
              CreateExperimentThirdStepPage(
                formKey: _formKey,
              ),
              CreateExperimentFourthStepPage(
                formKey: _formKey,
                listOfEnzymes:
                    controller.experimentRequestModel.experimentsEnzymes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
