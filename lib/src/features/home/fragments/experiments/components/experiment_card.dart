// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models/experiment_model.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/util/util.dart';
import '../../../../../shared/routes/route_generator.dart';
import '../experiments_controller.dart';

class ExperimentCard extends StatefulWidget {
  const ExperimentCard({
    Key? key,
    required this.experiment,
  }) : super(key: key);

  final ExperimentModel experiment;

  @override
  State<ExperimentCard> createState() => _ExperimentCardState();
}

class _ExperimentCardState extends State<ExperimentCard> {
  @override
  Widget build(BuildContext context) {
    context.watch<ExperimentsController>();

    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          RouteGenerator.experimentDetailed,
          arguments: widget.experiment,
        ) /* .then((_) => setState(() {})) */,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.experiment.name,
                      style: TextStyles.titleHome,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Modificado em ${Toolkit.formatBrDate(widget.experiment.updatedAt)}',
                      style: TextStyles.bodyMinRegular,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      widget.experiment.description,
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
                percent: widget.experiment.progress,
                center: Text(
                  Toolkit.doubleToPercentual(widget.experiment.progress),
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
      ),
    );
  }
}
