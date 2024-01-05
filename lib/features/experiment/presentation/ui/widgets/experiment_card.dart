// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/percent_indicator.dart';

// 🌎 Project imports:
import '../../../../../core/routing/routing.dart';
import '../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../shared/ui/ui.dart';
import '../../../../../shared/utils/utils.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../viewmodel/experiment_details_viewmodel.dart';

class ExperimentCard extends StatefulWidget {
  const ExperimentCard({
    super.key,
    required this.experiment,
    this.indexOfExperiment,
  });

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
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Material(
            elevation: 4,
            // shadowColor: context.getApplyedColorScheme.background,
            borderRadius: BorderRadius.circular(16),
            surfaceTintColor: context.getApplyedColorScheme.secondaryContainer,
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
                Radius.circular(16),
              ),
              child: Row(
                children: [
                  if (widget.indexOfExperiment != null)
                    Container(
                      decoration: BoxDecoration(
                        color: context.getApplyedColorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Center(
                          child: Text(
                            widget.indexOfExperiment.toString(),
                            style: TextStyles(context).titleMinBoldBackground(
                              color: context.getApplyedColorScheme.onPrimary,
                            ),
                          ),
                        ),
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
                          style:
                              TextStyles(context).titleMoreBoldHeadingColored,
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
                          style: TextStyles(context).bodyRegular.copyWith(
                                fontSize: 16.0,
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
                    lineWidth: 12.0,
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: widget.experiment.progress,
                    center: Text(
                      Toolkit.doubleToPercentual(widget.experiment.progress),
                      style: TextStyles(context).buttonPrimary,
                    ),
                    progressColor: context.getApplyedColorScheme.primary,
                    backgroundColor:
                        context.getApplyedColorScheme.primary.withOpacity(0.4),
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
