// 🐦 Flutter imports:
import 'package:flutter/material.dart';

import '../../../../../shared/l10n/app_localizations.dart';

class ExperimentExclusionDialog extends StatefulWidget {
  const ExperimentExclusionDialog({super.key});

  @override
  State<ExperimentExclusionDialog> createState() => _ExperimentExclusionDialogState();
}

class _ExperimentExclusionDialogState extends State<ExperimentExclusionDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.deleteExperimentTitle),
      content: Text(l10n.deleteExperimentContent),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.deleteButton)),
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton)),
      ],
    );
  }
}
