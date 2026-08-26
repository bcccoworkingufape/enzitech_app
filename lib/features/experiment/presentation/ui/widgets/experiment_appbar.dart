// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/extensions.dart';
import 'ezt_create_experiment_step_indicator.dart';

class ExperimentAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ExperimentAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight * 3);

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
      flexibleSpace: SafeArea(
        child: Column(
          children: [
            EZTCreateExperimentStepIndicator(
              title: context.l10n.registerNewExperiment,
              message: context.l10n.stepIndicatorIdentification(1, 4),
            ),
          ],
        ),
      ),
    );
  }
}
