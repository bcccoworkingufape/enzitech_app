// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

// 🌎 Project imports:
import '../../../../../../../shared/extensions/extensions.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../widgets/ezt_bottomsheet.dart';

class DeleteAccountBS extends StatefulWidget {
  final String email;

  const DeleteAccountBS({required this.email, super.key});

  @override
  State<DeleteAccountBS> createState() => _DeleteAccountBSState();
}

class _DeleteAccountBSState extends State<DeleteAccountBS> {
  final _controller = TextEditingController();
  bool _touched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _matches => _controller.text.trim().toLowerCase() == widget.email.trim().toLowerCase();

  Color get _errorColor => Theme.of(context).colorScheme.error;

  Widget _consequence(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(PhosphorIcons.x, size: 18, color: _errorColor),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyles(context).trailingRegular(), textAlign: TextAlign.start)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EZTBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Icon(PhosphorIcons.warningCircle, size: 48, color: _errorColor)),
          const SizedBox(height: 16),
          Center(
            child: Text(context.l10n.deleteAccountTitle, style: TextStyles.titleHome, textAlign: TextAlign.center),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              context.l10n.deleteAccountDescription,
              style: TextStyles(context).trailingRegular(isBold: true),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          _consequence(context.l10n.deleteAccountItemExperiments),
          _consequence(context.l10n.deleteAccountItemTreatments),
          _consequence(context.l10n.deleteAccountItemAccess),
          const SizedBox(height: 12),
          Text(context.l10n.deleteAccountConfirmationLabel, style: TextStyles(context).titleBoldHeading),
          const SizedBox(height: 8),
          EZTTextField(
            eztTextFieldType: EZTTextFieldType.underline,
            controller: _controller,
            hintText: widget.email,
            usePrimaryColorOnFocusedBorder: true,
            keyboardType: TextInputType.emailAddress,
            textCapitalization: TextCapitalization.none,
            onChanged: (_) => setState(() => _touched = true),
          ),
          if (_touched && !_matches && _controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                context.l10n.deleteAccountConfirmationMismatch,
                style: TextStyles(context).trailingRegular().copyWith(color: _errorColor),
              ),
            ),
          const SizedBox(height: 24),
          EZTButton(
            text: context.l10n.deleteAccountConfirmButton,
            color: _errorColor,
            enabled: _matches,
            onPressed: _matches ? () => Navigator.of(context).pop(true) : null,
          ),
          const SizedBox(height: 8),
          EZTButton(
            eztButtonType: EZTButtonType.outline,
            text: context.l10n.cancelButton,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
