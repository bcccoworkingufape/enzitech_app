// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

import '../../../../../../l10n/app_localizations.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';
import '../../viewmodel/enzymes_viewmodel.dart';

class EnzymesSummary extends StatefulWidget {
  const EnzymesSummary({
    super.key,
  });

  @override
  State<EnzymesSummary> createState() => _EnzymesSummaryState();
}

class _EnzymesSummaryState extends State<EnzymesSummary> {
  Widget enzymeTag(String name, int quantity, Color color) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: color,
            size: 16,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            l10n.enzymeTagFormat(name, quantity),
            style: TextStyles.bodyMinBold.copyWith(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var viewmodel = GetIt.I.get<EnzymesViewmodel>();

    final Map<String, String> enzymeTypeTranslations = {
      'BETA_GLUCOSIDASE': l10n.enzymeType_betaGlucosidase,
      'ARYL': l10n.enzymeType_aryl,
      'ACID_PHOSPHATASE': l10n.enzymeType_acidPhosphatase,
      'ALKALINE_PHOSPHATASE': l10n.enzymeType_alkalinePhosphatase,
      'UREASE': l10n.enzymeType_urease,
    };

    int getEnzymeCount(String typeKey) {
      if (viewmodel.enzymes.isEmpty) return 0;
      return viewmodel.enzymes
          .where((enzyme) => enzyme.type == typeKey)
          .length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        margin: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.getApplyedColorScheme.primary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Center(
                  child: Text(
                    l10n.enzymesSummaryTitle,
                    style: TextStyles.bodyMinBold.copyWith(
                      color: context.getApplyedColorScheme.onSecondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                enzymeTag(
                    enzymeTypeTranslations[Constants.typesOfEnzymesList[0]]!,
                    getEnzymeCount(Constants.typesOfEnzymesList[0]),
                    AppColors.betaGlucosidase),
                enzymeTag(
                    enzymeTypeTranslations[Constants.typesOfEnzymesList[1]]!,
                    getEnzymeCount(Constants.typesOfEnzymesList[1]),
                    AppColors.aryl),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            enzymeTag(
                enzymeTypeTranslations[Constants.typesOfEnzymesList[2]]!,
                getEnzymeCount(Constants.typesOfEnzymesList[2]),
                AppColors.fosfataseAcida),
            enzymeTag(
                enzymeTypeTranslations[Constants.typesOfEnzymesList[3]]!,
                getEnzymeCount(Constants.typesOfEnzymesList[3]),
                AppColors.fosfataseAlcalina),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                enzymeTag(
                    enzymeTypeTranslations[Constants.typesOfEnzymesList[4]]!,
                    getEnzymeCount(Constants.typesOfEnzymesList[4]),
                    AppColors.urease),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}
