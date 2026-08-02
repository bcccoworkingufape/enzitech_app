// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/extensions.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(PhosphorIcons.warningCircle(PhosphorIconsStyle.fill), color: context.getApplyedColorScheme.error),
      title: Text(context.l10n.deleteAccountDialogTitle, textAlign: TextAlign.center),
      content: Text(context.l10n.deleteAccountDialogContent, textAlign: TextAlign.center),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.cancelButton),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            context.l10n.deleteButton,
            style: TextStyle(color: context.getApplyedColorScheme.error, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
