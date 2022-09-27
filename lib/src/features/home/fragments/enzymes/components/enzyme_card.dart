// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models/enzyme_model.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';

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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.enzyme.name,
              style: TextStyles.titleHome,
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
