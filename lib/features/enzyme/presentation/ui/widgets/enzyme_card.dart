// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../shared/extensions/double_extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';

class EnzymeCard extends StatefulWidget {
  const EnzymeCard({
    Key? key,
    required this.enzyme,
  }) : super(key: key);

  final EnzymeEntity enzyme;

  @override
  State<EnzymeCard> createState() => _EnzymeCardState();
}

class _EnzymeCardState extends State<EnzymeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.white,
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
                  backgroundColor:
                      Constants.dealWithEnzymeChipColor(widget.enzyme.type),
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
            const Divider(),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Fórmula: ",
                  style: TextStyles.bodyRegular.copyWith(
                    color: AppColors.heading,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.enzyme.formula,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify,
                  style: TextStyles.bodyRegular
                      .copyWith(color: AppColors.heading, fontSize: 16),
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
                          widget.enzyme.variableA.formmatedNumber,
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
                    Wrap(
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
                          widget.enzyme.variableB.formmatedNumber,
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
          ],
        ),
      ),
    );
  }
}
