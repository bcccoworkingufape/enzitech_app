// 🐦 Flutter imports:
import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../viewmodel/experiment_results_viewmodel.dart';
import '../../../viewmodel/experiments_viewmodel.dart';

class ExperimentResultsPage extends StatefulWidget {
  const ExperimentResultsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExperimentResultsPage> createState() => _ExperimentResultsPageState();
}

class _ExperimentResultsPageState extends State<ExperimentResultsPage> {
  late final ExperimentResultsViewmodel _experimentResultsViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;

  @override
  void initState() {
    super.initState();
    _experimentResultsViewmodel = GetIt.I.get<ExperimentResultsViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();

    _experimentResultsViewmodel.fetch();

    if (mounted) {
      _experimentResultsViewmodel.addListener(
        () {
          if (mounted && _experimentResultsViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_experimentResultsViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  get _buildBody {
    if (_experimentResultsViewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(message: "Carregando resultados...");
    }

    return Text(_experimentResultsViewmodel
        .experimentResultEntity!.enzymes.length
        .toString());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _experimentResultsViewmodel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            title: Text(
              "Resultados do experimento",
              style: TextStyles.titleBoldBackground,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            // label: Text(
            //   "Compartilhar",
            //   style: TextStyles.buttonBoldBackground,
            // ),

            child: const Icon(
              PhosphorIcons.shareNetwork,
              size: 35,
              color: AppColors.white,
            ),
          ),
          body: _buildBody,
        );
      },
    );
  }
}
