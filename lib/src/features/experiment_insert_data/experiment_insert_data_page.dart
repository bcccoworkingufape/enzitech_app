// 🐦 Flutter imports:
import 'package:enzitech_app/src/shared/validator/validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_insert_data/experiment_insert_data_controller.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/fragments/experiment_choose_enzyme_and_treatment_page.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/fragments/experiment_fill_fields_page.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

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
  final _formKey = GlobalKey<FormBuilderState>();

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

  void onBack() {
    if (mounted) {
      controller.setChoosedEnzymeAndTreatment({
        "process": null,
        "enzyme": null,
        "experimentData": [],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentInsertDataController>();
    return Scaffold(
      key: _scaffoldKey,
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
              formKey: _formKey,
              callback: onBack,
            ),
            ExperimentFillFieldsPage(
              formKey: _formKey,
            ),
          ],
        ),
      ),
    );
  }
}
