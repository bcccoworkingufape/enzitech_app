// 🐦 Flutter imports:
import 'package:enzitech_app/src/shared/external/over_packages/marquee_on_demand.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import 'package:marquee/marquee.dart';

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
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: MarqueeOnDemand(
                      key: UniqueKey(),
                      // switchWidth: 100,
                      text: widget.enzyme.name,
                      textStyle: TextStyles.titleHome,
                      marqueeBuilder: (context, text, textStyle) => Marquee(
                        text: text,
                        style: textStyle,
                        scrollAxis: Axis.horizontal,
                        blankSpace: 20.0,
                        velocity: 10.0,
                      ),
                      textBuilder: (context, text, textStyle) => Text(
                        text,
                        style: textStyle,
                      ),
                    ),
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
            const SizedBox(
              height: 2,
            ),
            Text(
              'Criado em ${Toolkit.formatBrDate(widget.enzyme.createdAt!)}',
              style: TextStyles.bodyMinRegular,
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text(
                      "Variável A: ",
                      style: TextStyles.bodyRegular.copyWith(
                        color: AppColors.heading,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
