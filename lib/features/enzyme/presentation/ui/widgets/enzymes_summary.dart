// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../viewmodel/enzymes_viewmodel.dart';

class EnzymesSummary extends StatefulWidget {
  const EnzymesSummary({super.key});

  @override
  State<EnzymesSummary> createState() => _EnzymesSummaryState();
}

class _EnzymesSummaryState extends State<EnzymesSummary> {
  Widget enzymeTag(String name, int quantity, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Icon(Icons.circle, color: color, size: 16),
          const SizedBox(width: 8),
          Text(context.l10n.enzymeTagFormat(name, quantity), style: TextStyles.bodyMinBold.copyWith()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewmodel = GetIt.I.get<EnzymesViewmodel>();

    final Map<String, String> enzymeTypeTranslations = {
      'Betaglucosidase': context.l10n.enzymeType_betaGlucosidase,
      'Aryl': context.l10n.enzymeType_aryl,
      'FosfataseAcida': context.l10n.enzymeType_acidPhosphatase,
      'FosfataseAlcalina': context.l10n.enzymeType_alkalinePhosphatase,
      'Urease': context.l10n.enzymeType_urease,
      'FDA': context.l10n.enzymeType_fda,
    };

    final Map<String, Color> enzymeColors = {
      'Betaglucosidase': AppColors.betaGlucosidase,
      'Aryl': AppColors.aryl,
      'FosfataseAcida': AppColors.fosfataseAcida,
      'FosfataseAlcalina': AppColors.fosfataseAlcalina,
      'Urease': AppColors.urease,
      'FDA': Colors.purple,
    };

    int getEnzymeCount(String typeKey) {
      if (viewmodel.enzymes.isEmpty) return 0;
      return viewmodel.enzymes.where((enzyme) => enzyme.type == typeKey).length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
        margin: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.getApplyedColorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Center(
                  child: Text(
                    context.l10n.enzymesSummaryTitle,
                    style: TextStyles.bodyMinBold.copyWith(color: context.getApplyedColorScheme.onSecondary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Wrap(
                spacing: 16.0, // Espaço horizontal entre as tags
                runSpacing: 8.0, // Espaço vertical entre as linhas
                children: enzymeTypeTranslations.keys.map((backendKey) {
                  final count = getEnzymeCount(backendKey);

                  // Só mostra a tag se houver pelo menos uma enzima daquele tipo
                  if (count > 0) {
                    return enzymeTag(
                      enzymeTypeTranslations[backendKey]!, // Nome traduzido
                      count,
                      enzymeColors[backendKey] ?? Colors.grey, // Cor correspondente
                    );
                  }

                  // Retorna um widget vazio se não houver enzimas desse tipo
                  return const SizedBox.shrink();
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
