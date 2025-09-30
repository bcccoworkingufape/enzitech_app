// 🐦 Flutter imports:
import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../shared/extensions/double_extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';

class EnzymeCard extends StatefulWidget {
  const EnzymeCard({
    super.key,
    required this.enzyme,
  });

  final EnzymeEntity enzyme;

  @override
  State<EnzymeCard> createState() => _EnzymeCardState();
}

class _EnzymeCardState extends State<EnzymeCard> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat.yMd(locale).format(widget.enzyme.createdAt!);

    final Map<String, String> enzymeTypeTranslations = {
      'Betaglucosidase': l10n.enzymeType_betaGlucosidase,
      'Aryl': l10n.enzymeType_aryl,
      'FosfataseAcida': l10n.enzymeType_acidPhosphatase,
      'FosfataseAlcalina': l10n.enzymeType_alkalinePhosphatase,
      'Urease': l10n.enzymeType_urease,
      'FDA': l10n.enzymeType_fda,
    };

    final translatedEnzymeType = enzymeTypeTranslations[widget.enzyme.type] ?? widget.enzyme.type;

    return Card(
      elevation: 4,
      surfaceTintColor: context.getApplyedColorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: EZTMarqueeOnDemand(
                          text: widget.enzyme.name,
                          textStyle:
                              TextStyles(context).titleMoreBoldHeadingColored,
                        ),
                      ),
                      Text(
                        l10n.createdOn(formattedDate),
                        style: TextStyles.bodyMinRegular,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Theme(
                  data: ThemeData(
                    canvasColor:
                        Constants.dealWithEnzymeChipColor(widget.enzyme.type),
                  ),
                  child: Chip(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    backgroundColor:
                        Constants.dealWithEnzymeChipColor(widget.enzyme.type),
                    label: Text(
                      translatedEnzymeType,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.formulaLabel,
                  style: TextStyles(context).bodyRegular.copyWith(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  widget.enzyme.formula,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: TextStyles(context).bodyRegular.copyWith(
                        fontSize: 16.0,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.variableALabel,
                          style: TextStyles(context).bodyRegular.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.enzyme.variableA.formmatedNumber,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyles(context).bodyRegular,
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Wrap(
                      children: [
                        Text(
                          l10n.variableBLabel,
                          style: TextStyles(context).bodyRegular.copyWith(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          widget.enzyme.variableB.formmatedNumber,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyles(context).bodyRegular.copyWith(
                                fontSize: 16.0,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
