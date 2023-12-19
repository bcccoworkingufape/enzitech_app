// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../shared/ui/ui.dart';
import 'ezt_create_experiment_step_indicator.dart';

class ExperimentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ExperimentAppBar({Key? key})
      : preferredSize = const Size.fromHeight(kToolbarHeight * 3),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  State<ExperimentAppBar> createState() => _ExperimentAppBarState();
}

class _ExperimentAppBarState extends State<ExperimentAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120, // Set this height
      // leading: ,
      flexibleSpace: SafeArea(
        child: Container(
          // color: AppColors.white, //TODO: COLOR-FIX
          child: Column(
            children: const [
              EZTCreateExperimentStepIndicator(
                title: "Cadastre um novo experimento",
                message: "Etapa 1 de 4 - Identificação",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
