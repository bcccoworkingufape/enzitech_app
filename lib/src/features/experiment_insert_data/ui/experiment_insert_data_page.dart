// 🐦 Flutter imports:

// 🐦 Flutter imports:
import 'package:enzitech_app/src/features/experiment_insert_data/viewmodel/experiment_insert_data_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/state_enum.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/experiment_insert_data/ui/fragments/experiment_choose_enzyme_and_treatment_page.dart';
import 'package:enzitech_app/src/features/experiment_insert_data/ui/fragments/experiment_fill_fields_page.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

class ExperimentInsertDataPage extends StatefulWidget {
  final ExperimentEntity experiment;

  const ExperimentInsertDataPage({
    Key? key,
    required this.experiment,
  }) : super(key: key);

  @override
  State<ExperimentInsertDataPage> createState() =>
      _ExperimentInsertDataPageState();
}

class _ExperimentInsertDataPageState extends State<ExperimentInsertDataPage> {
  late final ExperimentInsertDataViewmodel viewmodel;
  late final ExperimentsViewmodel experimentsViewmodel;

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
    viewmodel = context.read<ExperimentInsertDataViewmodel>();
    experimentsViewmodel = context.read<ExperimentsViewmodel>();

    viewmodel.setExperiment(widget.experiment);

    if (mounted) {
      viewmodel.addListener(
        () {
          if (mounted && viewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(viewmodel.failure!),
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
            viewmodel.setChoosedEnzymeAndTreatment(
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
    context.watch<ExperimentInsertDataViewmodel>();
    return WillPopScope(
      onWillPop: () async {
        onBack();
        return viewmodel.pageController.page! > 0 ? false : true;
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
          child: PageView(
            controller: viewmodel.pageController,
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
