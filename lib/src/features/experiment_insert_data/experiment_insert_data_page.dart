// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_insert_data/experiment_insert_data_controller.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/fragments/experiment_choose_enzyme_and_treatment_page.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/fragments/experiment_fill_fields_page.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/shared/models_/experiment_model.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

class ExperimentInsertDataPage extends StatefulWidget {
  final ExperimentModel experiment;

  const ExperimentInsertDataPage({
    Key? key,
    required this.experiment,
  }) : super(key: key);

  @override
  State<ExperimentInsertDataPage> createState() =>
      _ExperimentInsertDataPageState();
}

class _ExperimentInsertDataPageState extends State<ExperimentInsertDataPage> {
  late final ExperimentInsertDataController controller;
  late final ExperimentsController experimentsController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  bool _ageHasError = false;
  bool _genderHasError = false;

  var genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentInsertDataController>();
    experimentsController = context.read<ExperimentsController>();

    controller.setExperimentModel(widget.experiment);

    if (mounted) {
      controller.addListener(
        () {
          if (mounted && controller.state == ExperimentInsertDataState.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  void onBack({int? page}) {
    if (mounted) {
      if (page != null) {
        controller.pageController.animateToPage(
          page,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeIn,
        );
      } else {
        {
          if (controller.pageController.page! > 0) {
            controller.pageController.animateToPage(
              controller.pageController.page!.toInt() - 1,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeIn,
            );
          } else {
            controller.setChoosedEnzymeAndTreatment(
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
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentInsertDataController>();
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return controller.pageController.page! > 0 ? false : true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,

        /* appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: Text(
            "Inserir dados no experimento",
            style: TextStyles.titleBoldBackground,
          ),
        ), */
        body: SafeArea(
          child: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ExperimentChooseEnzymeAndTreatmentPage(
                // formKey: _formKey,
                callback: onBack,
              ),
              ExperimentFillFieldsPage(
                // formKey: _formKey,
                callback: onBack,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
