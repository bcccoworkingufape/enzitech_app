// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'ezt_create_experiment_step_indicator.dart';

class ExperimentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ExperimentAppBar({super.key})
      : preferredSize = const Size.fromHeight(kToolbarHeight * 3);

  @override
  final Size preferredSize; //* Default is 56.0

  @override
  State<ExperimentAppBar> createState() => _ExperimentAppBarState();
}

class _ExperimentAppBarState extends State<ExperimentAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 120,
      flexibleSpace: const SafeArea(
        child: Column(
          children: [
            EZTCreateExperimentStepIndicator(
              title: "Cadastre um novo experimento",
              message: "Etapa 1 de 4 - Identificação",
            ),
          ],
        ),
      ),
    );
  }
}
