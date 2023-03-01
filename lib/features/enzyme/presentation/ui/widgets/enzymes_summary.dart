// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';

// 🌎 Project imports:
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';
import '../../viewmodel/enzymes_viewmodel.dart';

class EnzymesSummary extends StatefulWidget {
  const EnzymesSummary({
    Key? key,
    // required this.enzymes,
    // this.indexOfExperiment,
  }) : super(key: key);

  // final List<EnzymeModel> enzymes;
  // final int? indexOfExperiment;

  @override
  State<EnzymesSummary> createState() => _EnzymesSummaryState();
}

class _EnzymesSummaryState extends State<EnzymesSummary> {
  Widget enzymeTag(String name, int quantity, Color color) {
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
            "$name ($quantity)",
            style: TextStyles.bodyMinBold.copyWith(color: AppColors.greySweet),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var viewmodel = GetIt.I.get<EnzymesViewmodel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
            // bottomRight: Radius.circular(8),
          ),
        ),
        margin: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Center(
                  child: Text(
                    "Sumário de enzimas",
                    style:
                        TextStyles.bodyMinBold.copyWith(color: AppColors.white),
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
                    Constants.typesOfEnzymesListFormmated[0],
                    viewmodel.enzymes
                        .map((element) =>
                            element.type == Constants.typesOfEnzymesList[0]
                                ? 1
                                : 0)
                        .reduce((value, element) => value + element),
                    AppColors.betaGlucosidase),
                enzymeTag(
                    Constants.typesOfEnzymesListFormmated[1],
                    viewmodel.enzymes
                        .map((element) =>
                            element.type == Constants.typesOfEnzymesList[1]
                                ? 1
                                : 0)
                        .reduce((value, element) => value + element),
                    AppColors.aryl),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                enzymeTag(
                    Constants.typesOfEnzymesListFormmated[2],
                    viewmodel.enzymes
                        .map((element) =>
                            element.type == Constants.typesOfEnzymesList[2]
                                ? 1
                                : 0)
                        .reduce((value, element) => value + element),
                    AppColors.fosfataseAcida),
                enzymeTag(
                    Constants.typesOfEnzymesListFormmated[3],
                    viewmodel.enzymes
                        .map((element) =>
                            element.type == Constants.typesOfEnzymesList[3]
                                ? 1
                                : 0)
                        .reduce((value, element) => value + element),
                    AppColors.fosfataseAlcalina),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                enzymeTag(
                    Constants.typesOfEnzymesListFormmated[4],
                    viewmodel.enzymes
                        .map((element) =>
                            element.type == Constants.typesOfEnzymesList[4]
                                ? 1
                                : 0)
                        .reduce((value, element) => value + element),
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
