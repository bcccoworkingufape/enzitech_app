// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_insert_data/experiment_insert_data_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class ExperimentChooseEnzymeAndTreatmentPage extends StatefulWidget {
  const ExperimentChooseEnzymeAndTreatmentPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExperimentChooseEnzymeAndTreatmentPage> createState() =>
      _ExperimentChooseEnzymeAndTreatmentPageState();
}

class _ExperimentChooseEnzymeAndTreatmentPageState
    extends State<ExperimentChooseEnzymeAndTreatmentPage> {
  late final ExperimentInsertDataController controller;
  late final ExperimentsController experimentsController;

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentInsertDataController>();
    experimentsController = context.read<ExperimentsController>();

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

  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentInsertDataController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Inserir dados no experimento",
          style: TextStyles.titleBoldBackground,
        ),
      ),
      body: Container(),
    );
  }
}
