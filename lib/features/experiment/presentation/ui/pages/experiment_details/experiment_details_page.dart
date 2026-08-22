// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/platform/secure_screen_wrapper.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../../shared/utils/utils.dart';
import '../../../../../main/presentation/viewmodel/home_viewmodel.dart';
import '../../../viewmodel/calculate_experiment_viewmodel.dart';
import '../../../viewmodel/experiment_details_viewmodel.dart';
import '../../../viewmodel/experiments_viewmodel.dart';
import '../../widgets/experiment_exclusion_dialog.dart';

class ExperimentDetailsPage extends StatefulWidget {
  const ExperimentDetailsPage({super.key});

  @override
  State<ExperimentDetailsPage> createState() => _ExperimentDetailsPageState();
}

class _ExperimentDetailsPageState extends State<ExperimentDetailsPage> with SecureScreenMixin {
  late final ExperimentDetailsViewmodel _experimentDetailsViewmodel;
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final HomeViewmodel _homeViewmodel;

  bool _expandToSeeMoreVisible = false;

  @override
  void initState() {
    super.initState();
    _experimentDetailsViewmodel = GetIt.I.get<ExperimentDetailsViewmodel>();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();

    if (mounted) {
      _experimentDetailsViewmodel.addListener(() {
        if (mounted && _experimentDetailsViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(context.l10n, _experimentDetailsViewmodel.failure!),
            eztSnackBarType: EZTSnackBarType.error,
          );
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Column _buildInfoBadge(int quantity, String name) {
    return Column(
      children: [
        Text(quantity.toString(), style: TextStyles.titleHome),
        const SizedBox(height: 5),
        Text(name, style: TextStyles(context).detailRegular),
      ],
    );
  }

  List<Text> get leadWithEnzymes {
    if (_experimentDetailsViewmodel.experiment!.enzymes != null) {
      if (_experimentDetailsViewmodel.experiment!.enzymes!.isNotEmpty) {
        return _experimentDetailsViewmodel.experiment!.enzymes!.map((element) => Text(element.name)).toList();
      }
    }
    return [Text(context.l10n.noData)];
  }

  List<Text> get leadWithTreatments {
    if (_experimentDetailsViewmodel.experiment!.treatments != null) {
      if (_experimentDetailsViewmodel.experiment!.treatments!.isNotEmpty) {
        return _experimentDetailsViewmodel.experiment!.treatments!.map((element) => Text(element.name)).toList();
      }
    }
    return [Text(context.l10n.noData)];
  }

  Widget _buildCard({required Widget child, Color? color}) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? context.getApplyedColorScheme.secondaryContainer.withValues(alpha: 0.25),
        borderRadius: const BorderRadius.all(Radius.circular(32)),
      ),
      child: Padding(padding: const EdgeInsets.all(32.0), child: child),
    );
  }

  Widget _buildBody(double height) {
    if (_experimentDetailsViewmodel.state == StateEnum.error) {
      return EZTError(message: context.l10n.errorLoadingExperiment(_experimentDetailsViewmodel.experiment!.name));
    }

    if (_experimentDetailsViewmodel.state == StateEnum.loading) {
      return EZTProgressIndicator(message: context.l10n.loadingExperiment);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            _buildCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularPercentIndicator(
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    radius: 60,
                    lineWidth: 16.0,
                    percent: _experimentDetailsViewmodel.experiment!.progress,
                    center: Text(
                      Toolkit.doubleToPercentual(_experimentDetailsViewmodel.experiment!.progress),
                      style: TextStyles(context).titleBoldHeading,
                    ),
                    progressColor: context.getApplyedColorScheme.primary,
                    backgroundColor: context.getApplyedColorScheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          _experimentDetailsViewmodel.experiment!.name,
                          style: TextStyles(context).titleBoldBackground(fontSize: 26),
                          maxLines: 2,
                          minFontSize: 24,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        AutoSizeText(
                          _experimentDetailsViewmodel.experiment!.description,
                          style: TextStyles(context).trailingRegular(),
                          maxLines: 4,
                          minFontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => setState(() {
                _expandToSeeMoreVisible = !_expandToSeeMoreVisible;
              }),
              child: _buildCard(
                color: context.getApplyedColorScheme.tertiaryContainer.withValues(alpha: 0.25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoBadge(
                          _experimentDetailsViewmodel.experiment!.treatments!.length,
                          context.l10n.treatments,
                        ),
                        _buildInfoBadge(_experimentDetailsViewmodel.experiment!.repetitions, context.l10n.repetitions),
                        _buildInfoBadge(_experimentDetailsViewmodel.experiment!.enzymes!.length, context.l10n.enzymes),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 24.0, bottom: !_expandToSeeMoreVisible ? 0 : 24.0),
                      child: Text(
                        !_expandToSeeMoreVisible ? context.l10n.tapToSeeMore : context.l10n.tapToHide,
                        style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                      ),
                    ),
                    if (_expandToSeeMoreVisible) ...[
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: leadWithTreatments),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: leadWithEnzymes),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            EZTButton(
              text: context.l10n.enzymaticCalculation,
              enabled: _experimentDetailsViewmodel.experiment!.progress != 1,
              icon: Icon(
                PhosphorIcons.function(),
                color: _experimentDetailsViewmodel.experiment!.progress < 1.0
                    ? context.getApplyedColorScheme.onPrimary
                    : context.getApplyedColorScheme.primary,
                size: 30,
              ),
              onPressed: () {
                GetIt.I.get<CalculateExperimentViewmodel>.call().clearTemporaryInfos();
                Navigator.pushNamed(
                  context,
                  Routing.calculateExperiment,
                  arguments: _experimentDetailsViewmodel.experiment!,
                );
              },
            ),
            const SizedBox(height: 20),
            EZTButton(
              text: context.l10n.results,
              enabled: _experimentDetailsViewmodel.experiment!.progress != 0,
              icon: Icon(
                PhosphorIcons.fileText(),
                color: _experimentDetailsViewmodel.experiment!.progress != 0
                    ? context.getApplyedColorScheme.onPrimary
                    : context.getApplyedColorScheme.primary,
                size: 30,
              ),
              onPressed: () => Navigator.pushNamed(context, Routing.experimentResults),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _experimentDetailsViewmodel,
      builder: (context, child) {
        return wrapSecureScreen(
      child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: context.getApplyedColorScheme.onSurface),
            title: Text(context.l10n.experimentDetails, style: TextStyles(context).titleBoldBackground()),
            actions: [
              if (_experimentDetailsViewmodel.state == StateEnum.success)
                IconButton(
                  tooltip: context.l10n.editExperimentTooltip,
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routing.editExperiment,
                      arguments: _experimentDetailsViewmodel.experiment!,
                    );
                  },
                  icon: Icon(PhosphorIcons.pencilSimple(), color: context.getApplyedColorScheme.onSurface, size: 25),
                ),
              if (_experimentDetailsViewmodel.state == StateEnum.success)
                IconButton(
                  onPressed: () async {
                    var shouldDelete = _homeViewmodel.accountViewmodel.enableExcludeConfirmation!
                        ? await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return const ExperimentExclusionDialog();
                            },
                          )
                        : null;

                    if (shouldDelete != null) {
                      if (!shouldDelete) return;
                    }

                    _experimentsViewmodel.deleteExperiment(_experimentDetailsViewmodel.experiment!.id);

                    if (mounted) {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);

                        EZTSnackBar.clear(context);
                        EZTSnackBar.show(
                          context,
                          context.l10n.experimentDeleted(_experimentDetailsViewmodel.experiment!.name),
                          eztSnackBarType: EZTSnackBarType.error,
                        );
                      });
                    }
                  },
                  icon: Icon(PhosphorIcons.trash(), color: context.getApplyedColorScheme.onSurface, size: 25),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildBody(MediaQuery.of(context).size.height),
          ),
        ),
      );
    },
  );
  }
}



