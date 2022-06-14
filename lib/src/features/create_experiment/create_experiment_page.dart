// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_first_step.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_fourth_step.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_second_step.dart';
import 'package:enzitech_app/src/features/create_experiment/widgets/create_experiment_third_step.dart';

class CreateExperimentPage extends StatefulWidget {
  const CreateExperimentPage({Key? key}) : super(key: key);

  @override
  State<CreateExperimentPage> createState() => _CreateExperimentPageState();
}

class _CreateExperimentPageState extends State<CreateExperimentPage> {
  final _pageController = PageController(initialPage: 0);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var experimentDataCache = {
    "name": "",
    "description": "",
    "treatment": "",
    "repetitions": "",
    "enzymeSelection": "",
    "varA": "",
    "varB": "",
    "var1": "",
    "var2": "",
    "var3": "",
    "var4": "",
    "enableNextButton1": "",
    "enableNextButton2": "",
    "enableNextButton3": "",
    "createExperimentButton": "",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            CreateExperimentFirstStepPage(
              pageController: _pageController,
              formKey: _formKey,
              experimentDataCache: experimentDataCache,
            ),
            CreateExperimentSecondStepPage(
              pageController: _pageController,
              formKey: _formKey,
              experimentDataCache: experimentDataCache,
            ),
            CreateExperimentThirdStepPage(
              pageController: _pageController,
              formKey: _formKey,
              experimentDataCache: experimentDataCache,
            ),
            CreateExperimentFourthStepPage(
              pageController: _pageController,
              formKey: _formKey,
              experimentDataCache: experimentDataCache,
            ),
          ],
        ),
      ),
    );
  }
}
