// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/create_experiment_controller.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_first_step.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_fourth_step.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_second_step.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_third_step.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class CreateExperimentPage extends StatefulWidget {
  const CreateExperimentPage({Key? key}) : super(key: key);

  @override
  State<CreateExperimentPage> createState() => _CreateExperimentPageState();
}

class _CreateExperimentPageState extends State<CreateExperimentPage> {
  late final CreateExperimentController controller;

  // final _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = context.read<CreateExperimentController>();
    // experimentDataCache.updateAll((key, value) => '');
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
          EZTSnackBar.show(
            context,
            "Experimento criado com sucesso!",
            eztSnackBarType: EZTSnackBarType.success,
          );

          if (!mounted) return;
          Navigator.popAndPushNamed(
            context,
            RouteGenerator.experiment,
          );
        }
      });
    }
  }

  // var experimentDataCache = {
  //   "name": "",
  //   "description": "",
  //   "treatment": "",
  //   "repetitions": "",
  //   "enzymeSelection": "",
  //   "varA": "",
  //   "varB": "",
  //   "var1": "",
  //   "var2": "",
  //   "var3": "",
  //   "var4": "",
  //   "enableNextButton1": "",
  //   "enableNextButton2": "",
  //   "enableNextButton3": "",
  //   "createExperimentButton": "",
  // };

  // var experimentDataCacheParaMudar = {
  //   "name": "",
  //   "description": "",
  //   "repetitions": "",
  //   "processes": [].toString(),
  //   "experimentsEnzymes": [].toString(),
  //   "enableNextButton1": "",
  //   "enableNextButton2": "",
  //   "enableNextButton3": "",
  //   "createExperimentButton": "",
  // };

  // ExperimentRequestModel experimentRequestModel = ExperimentRequestModel(
  //   name: "",
  //   description: "",
  //   repetitions: 0,
  //   processes: [],
  //   experimentsEnzymes: [],
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: PageView(
          controller: controller.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CreateExperimentFirstStepPage(
              // pageController: _pageController,
              formKey: _formKey,
              // experimentDataCache: experimentDataCacheParaMudar,
              // experimentRequestModel: experimentRequestModel,
            ),
            CreateExperimentSecondStepPage(
              // pageController: _pageController,
              formKey: _formKey,
              // experimentRequestModel: experimentRequestModel,

              // experimentDataCache: experimentDataCacheParaMudar,
            ),
            CreateExperimentThirdStepPage(
              // pageController: _pageController,
              formKey: _formKey,
              // experimentRequestModel: experimentRequestModel,

              // experimentDataCache: experimentDataCacheParaMudar,
            ),
            CreateExperimentFourthStepPage(
              // pageController: _pageController,
              formKey: _formKey,
              listOfEnzymes:
                  controller.experimentRequestModel.experimentsEnzymes,
              //  experimentRequestModel: experimentRequestModel,

              // experimentDataCache: experimentDataCacheParaMudar,
            ),
          ],
        ),
      ),
    );
  }
}
