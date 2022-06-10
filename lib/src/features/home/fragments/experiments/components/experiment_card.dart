// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:percent_indicator/percent_indicator.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';

class ExperimentCard extends StatefulWidget {
  const ExperimentCard({
    Key? key,
    required this.name,
    required this.updatedAt,
    required this.description,
    required this.progress,
  }) : super(key: key);

  final String name;
  final DateTime updatedAt;
  final String description;
  final double progress;

  @override
  State<ExperimentCard> createState() => _ExperimentCardState();
}

class _ExperimentCardState extends State<ExperimentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyles.titleHome,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Modificado em ${Toolkit.formatBrDate(widget.updatedAt)}',
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
            const SizedBox(
              width: 32,
            ),
            CircularPercentIndicator(
              radius: 40,
              lineWidth: 10.0,
              percent: widget.progress,
              center: Text(
                '${((widget.progress) * 100).round()}%',
                style: TextStyles.buttonPrimary,
              ),
              progressColor: AppColors.primary,
              backgroundColor: AppColors.primary.withOpacity(0.4),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
