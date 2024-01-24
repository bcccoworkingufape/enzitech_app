// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class ExperimentExclusionDialog extends StatefulWidget {
  const ExperimentExclusionDialog({
    super.key,
  });

  @override
  State<ExperimentExclusionDialog> createState() =>
      _ExperimentExclusionDialogState();
}

class _ExperimentExclusionDialogState extends State<ExperimentExclusionDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir o experimento?'),
      content:
          const Text('Você tem certeza que deseja excluir este experimento?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("EXCLUIR")),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("CANCELAR"),
        ),
      ],
    );
  }
}
