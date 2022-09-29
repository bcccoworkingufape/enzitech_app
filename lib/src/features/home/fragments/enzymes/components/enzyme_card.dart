// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_marquee_on_demand.dart';

// 📦 Package imports:

class EnzymeCard extends StatefulWidget {
  const EnzymeCard({
    Key? key,
    required this.enzyme,
  }) : super(key: key);

  final EnzymeModel enzyme;

  @override
  State<EnzymeCard> createState() => _EnzymeCardState();
}

class _EnzymeCardState extends State<EnzymeCard> {
  get dealWithChipColor {
    if (widget.enzyme.type == Constants.betaGlucosidase) {
      return AppColors.betaGlucosidase;
    } else if (widget.enzyme.type == Constants.aryl) {
      return AppColors.aryl;
    } else if (widget.enzyme.type == Constants.fosfataseAcida) {
      return AppColors.fosfataseAcida;
    } else if (widget.enzyme.type == Constants.fosfataseAlcalina) {
      return AppColors.fosfataseAlcalina;
    } else {
      return AppColors.grenDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
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
                      // Text(
                      //   widget.enzyme.name,
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyles.titleBoldHeading,
                      // ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: EZTMarqueeOnDemand(
                          text: widget.enzyme.name,
                          textStyle: TextStyles.titleBoldHeading,
                        ),
                      ),
                      Text(
                        'Criado em ${Toolkit.formatBrDate(widget.enzyme.createdAt!)}',
                        style: TextStyles.bodyMinRegular,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Chip(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: dealWithChipColor,
                  label: Text(
                      Constants.typesOfEnzymesListFormmated[Constants
                          .typesOfEnzymesList
                          .indexOf(widget.enzyme.type)],
                      style: const TextStyle(color: Colors.white)),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 2,
            // ),
            // Text(
            //   'Criado em ${Toolkit.formatBrDate(widget.enzyme.createdAt!)}',
            //   style: TextStyles.bodyMinRegular,
            // ),
            const SizedBox(
              height: 2,
            ),
            const Divider(),
            const SizedBox(
              height: 2,
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
                          "Variável A: ",
                          style: TextStyles.bodyRegular.copyWith(
                            color: AppColors.heading,
                            fontSize: 16,
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
                          widget.enzyme.variableA.toString(),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.justify,
                          style: TextStyles.bodyRegular
                              .copyWith(color: AppColors.heading, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Variável B: ",
                      style: TextStyles.bodyRegular.copyWith(
                        color: AppColors.heading,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.enzyme.variableB.toString(),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.justify,
                      style: TextStyles.bodyRegular
                          .copyWith(color: AppColors.heading, fontSize: 16),
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
