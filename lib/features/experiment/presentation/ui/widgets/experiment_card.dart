// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
// 📦 Package imports:
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/routing/routing.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../viewmodel/experiment_details_viewmodel.dart';

class ExperimentCard extends StatefulWidget {
  const ExperimentCard({
    Key? key,
    required this.experiment,
    this.indexOfExperiment,
  }) : super(key: key);

  final ExperimentEntity experiment;
  final int? indexOfExperiment;

  @override
  State<ExperimentCard> createState() => _ExperimentCardState();
}

class _ExperimentCardState extends State<ExperimentCard> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Material(
            elevation: 8,
            shadowColor: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                GetIt.I
                    .get<ExperimentDetailsViewmodel>()
                    .getExperimentDetails(widget.experiment.id);
                Navigator.pushNamed(
                  context,
                  Routing.experimentDetailed,
                  arguments: widget.experiment,
                );
              },
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              child: Row(
                children: [
                  if (widget.indexOfExperiment != null)
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                            child: Text(
                          widget.indexOfExperiment.toString(),
                          style: TextStyles.titleMinBoldBackground,
                        )),
                      ),
                    ),
                  if (widget.indexOfExperiment != null)
                    const SizedBox(
                      width: 8,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.experiment.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.titleBoldHeading,
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
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.bodyRegular.copyWith(
                            // color: AppColors.greyLight, //TODO: COLOR-FIX
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
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
        ),
      ),
    );
  }
}
