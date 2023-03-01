// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';

class TreatmentCard extends StatefulWidget {
  const TreatmentCard({
    Key? key,
    required this.name,
    required this.createdAt,
    required this.description,
  }) : super(key: key);

  final String name;
  final DateTime createdAt;
  final String description;

  @override
  State<TreatmentCard> createState() => _TreatmentCardState();
}

class _TreatmentCardState extends State<TreatmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   widget.name,
            //   style: TextStyles.titleBoldHeading,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: EZTMarqueeOnDemand(
                text: widget.name,
                textStyle: TextStyles.titleBoldHeading,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              'Criado em ${Toolkit.formatBrDate(widget.createdAt)}',
              style: TextStyles.bodyMinRegular,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              widget.description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
              style: TextStyles.bodyRegular
                  .copyWith(color: AppColors.greyLight, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
