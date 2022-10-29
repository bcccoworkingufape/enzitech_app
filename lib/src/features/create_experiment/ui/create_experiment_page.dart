// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/ui/fragments/create_experiment_first_step.dart';
import 'package:enzitech_app/src/features/create_experiment/ui/fragments/create_experiment_fourth_step.dart';
import 'package:enzitech_app/src/features/create_experiment/ui/fragments/create_experiment_second_step.dart';
import 'package:enzitech_app/src/features/create_experiment/ui/fragments/create_experiment_third_step.dart';
import 'package:enzitech_app/src/features/create_experiment/viewmodel/create_experiment_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/business/infra/models/experiment_request_model.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class CreateExperimentPage extends StatefulWidget {
  const CreateExperimentPage({Key? key}) : super(key: key);

  @override
  State<CreateExperimentPage> createState() => _CreateExperimentPageState();
}

class _CreateExperimentPageState extends State<CreateExperimentPage> {
  late final CreateExperimentViewmodel viewmodel;
  late final ExperimentsViewmodel experimentsViewmodel;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<CreateExperimentViewmodel>();
    experimentsViewmodel = context.read<ExperimentsViewmodel>();

    if (mounted) {
      viewmodel.addListener(() {
        if (mounted && viewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(
              viewmodel.failure!,
              enableStatusCode: true,
              overrideDefaultMessage: true,
            ),
            eztSnackBarType: EZTSnackBarType.error,
          );
        } else if (viewmodel.state == StateEnum.success &&
            viewmodel.experimentCreated) {
          if (mounted) {
            viewmodel.experimentCreated = false;
            viewmodel.setExperimentRequestModel(
              ExperimentRequestModel(
                name: "",
                description: "",
                repetitions: 0,
                processes: [],
                experimentsEnzymes: [],
              ),
            );

            // reload the experiments list
            // TODO: Verify this (maybe not loading recent created experiment if > 10)
            experimentsViewmodel.loadExperiments(1);

            EZTSnackBar.show(
              context,
              "Experimento criado com sucesso!",
              eztSnackBarType: EZTSnackBarType.success,
            );

            if (!mounted) return;
            Navigator.popAndPushNamed(
              context,
              RouteGenerator.experimentDetailed,
              arguments: viewmodel.experiment,
            );

            viewmodel.setExperiment(null);
          }
        }
      });
    }
  }

  void onBack2() {
    if (mounted) {
      viewmodel.experimentCreated = false;
      viewmodel.setExperimentRequestModel(
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

  void onBack({int? page}) {
    if (mounted) {
      if (page != null) {
        viewmodel.pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      } else {
        {
          if (viewmodel.pageController.page! > 0) {
            viewmodel.pageController.animateToPage(
              viewmodel.pageController.page!.toInt() - 1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          } else {
            viewmodel.setExperimentRequestModel(
              ExperimentRequestModel(
                name: "",
                description: "",
                repetitions: 0,
                processes: [],
                experimentsEnzymes: [],
              ),
            );
            Navigator.pop(context);
          }
        }
      }
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
        return viewmodel.pageController.page! > 0 ? false : true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: PageView(
            controller: viewmodel.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CreateExperimentFirstStepPage(
                callback: onBack,
                formKey: _formKey,
              ),
              CreateExperimentSecondStepPage(
                callback: onBack,
                formKey: _formKey,
              ),
              CreateExperimentThirdStepPage(
                callback: onBack,
                formKey: _formKey,
              ),
              CreateExperimentFourthStepPage(
                callback: onBack,
                formKey: _formKey,
                listOfEnzymes:
                    viewmodel.experimentRequestModel.experimentsEnzymes,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
