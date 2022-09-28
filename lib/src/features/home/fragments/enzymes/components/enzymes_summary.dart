// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';

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
    var controller = context.watch<EnzymesController>();

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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  enzymeTag(
                      Constants.typesOfEnzymesListFormmated[0],
                      controller.enzymes
                          .map((element) =>
                              element.type == Constants.typesOfEnzymesList[0]
                                  ? 1
                                  : 0)
                          .reduce((value, element) => value + element),
                      AppColors.betaGlucosidase),
                  enzymeTag(
                      Constants.typesOfEnzymesListFormmated[1],
                      controller.enzymes
                          .map((element) =>
                              element.type == Constants.typesOfEnzymesList[1]
                                  ? 1
                                  : 0)
                          .reduce((value, element) => value + element),
                      AppColors.aryl),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  enzymeTag(
                      Constants.typesOfEnzymesListFormmated[2],
                      controller.enzymes
                          .map((element) =>
                              element.type == Constants.typesOfEnzymesList[2]
                                  ? 1
                                  : 0)
                          .reduce((value, element) => value + element),
                      AppColors.fosfataseAcida),
                  enzymeTag(
                      Constants.typesOfEnzymesListFormmated[3],
                      controller.enzymes
                          .map((element) =>
                              element.type == Constants.typesOfEnzymesList[3]
                                  ? 1
                                  : 0)
                          .reduce((value, element) => value + element),
                      AppColors.fosfataseAlcalina),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}