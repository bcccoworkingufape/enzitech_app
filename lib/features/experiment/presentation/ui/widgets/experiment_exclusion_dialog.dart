// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/extensions.dart';

class ExperimentExclusionDialog extends StatefulWidget {
  const ExperimentExclusionDialog({super.key});

  @override
  State<ExperimentExclusionDialog> createState() => _ExperimentExclusionDialogState();
}

class _ExperimentExclusionDialogState extends State<ExperimentExclusionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.l10n.deleteExperimentTitle),
      content: Text(context.l10n.deleteExperimentContent),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(context.l10n.deleteButton)),
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(context.l10n.cancelButton)),
      ],
    );
  }
}
