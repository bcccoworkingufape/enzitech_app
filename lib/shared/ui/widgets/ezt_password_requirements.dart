// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

// 🌎 Project imports:
import '../../extensions/build_context_extensions.dart';
import '../../validator/validator.dart';
import '../themes/themes.dart';

class EZTPasswordRequirements extends StatelessWidget {
  const EZTPasswordRequirements({super.key, required this.password});

  final String password;

  Widget _requirementRow(BuildContext context, String label, bool isMet) {
    final color = isMet ? context.getApplyedColorScheme.primary : context.getApplyedColorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isMet ? PhosphorIcons.checkCircleFill : PhosphorIcons.circle,
              key: ValueKey(isMet),
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyles.bodyMinRegular.copyWith(
              color: color,
              fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.getApplyedColorScheme.primaryContainer.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(PhosphorIcons.shieldCheck, size: 16, color: context.getApplyedColorScheme.primary),
              const SizedBox(width: 6),
              Text(
                context.l10n.passwordRequirementsTitle,
                style: TextStyles.bodyMinBold.copyWith(color: context.getApplyedColorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _requirementRow(context, context.l10n.passwordRequirement_minLength, password.length >= 8),
          _requirementRow(
            context,
            context.l10n.passwordRequirement_uppercase,
            Validator.containUppercaseLetter(password),
          ),
          _requirementRow(
            context,
            context.l10n.passwordRequirement_lowercase,
            Validator.containLowercaseLetter(password),
          ),
          _requirementRow(
            context,
            context.l10n.passwordRequirement_specialChar,
            Validator.containSpetialChars(password),
          ),
        ],
      ),
    );
  }
}
