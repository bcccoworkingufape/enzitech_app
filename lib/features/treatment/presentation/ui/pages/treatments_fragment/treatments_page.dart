// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/extensions/build_context_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../main/presentation/viewmodel/settings_viewmodel.dart';
import '../../../viewmodel/treatments_viewmodel.dart';
import '../../widgets/treatment_card.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({super.key});

  @override
  State<TreatmentsPage> createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  late final TreatmentsViewmodel _treatmentsViewmodel;
  final Key _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();
    if (mounted) {
      _treatmentsViewmodel.addListener(() {
        if (mounted && _treatmentsViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(context.l10n, _treatmentsViewmodel.failure!),
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

  Widget _buildTreatmentsList(double height) {
    if (_treatmentsViewmodel.state == StateEnum.error) {
      return EZTForcedCenter(child: EZTError(message: context.l10n.errorLoadingTreatments));
    }

    if (_treatmentsViewmodel.state == StateEnum.loading) {
      return EZTProgressIndicator(message: context.l10n.loadingTreatments);
    }

    if (_treatmentsViewmodel.state == StateEnum.success && _treatmentsViewmodel.treatments.isEmpty) {
      return EZTForcedCenter(child: EZTNotFound(message: context.l10n.treatmentsNotFound));
    }

    return ListView.builder(
      controller: _treatmentsViewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: _treatmentsViewmodel.treatments.length,
      itemBuilder: (context, index) {
        var treatment = _treatmentsViewmodel.treatments[index];
        return Column(
          children: [
            Dismissible(
              key: Key(treatment.id),
              onDismissed: (direction) {
                setState(() {
                  _treatmentsViewmodel.treatments.removeAt(index);
                });

                EZTSnackBar.clear(context);

                bool permanentlyDeleted = true;

                EZTSnackBar.show(
                  context,
                  context.l10n.treatmentDeleted(treatment.name),
                  eztSnackBarType: EZTSnackBarType.error,
                  action: SnackBarAction(
                    label: context.l10n.undo,
                    textColor: context.getApplyedColorScheme.onError,
                    onPressed: () {
                      setState(() {
                        _treatmentsViewmodel.treatments.insert(index, treatment);
                        permanentlyDeleted = false;
                      });
                    },
                  ),
                  onDismissFunction: () async {
                    if (permanentlyDeleted) {
                      await _treatmentsViewmodel.deleteTreatment(treatment.id);
                    }
                  },
                );
              },
              background: Container(
                color: context.getApplyedColorScheme.error,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(PhosphorIcons.trash(PhosphorIconsStyle.light), color: context.getApplyedColorScheme.onError),
                      Text(
                        context.l10n.delete,
                        style: TextStyle(color: context.getApplyedColorScheme.onError),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: GetIt.I.get<SettingsViewmodel>().enableExcludeConfirmation!
                  ? (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(context.l10n.deleteTreatmentTitle),
                            content: Text(context.l10n.deleteTreatmentContent),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text(context.l10n.deleteButton),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(context.l10n.cancelButton),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              child: TreatmentCard(
                name: treatment.name,
                createdAt: treatment.createdAt!,
                description: treatment.description,
              ),
            ),
            if (index == _treatmentsViewmodel.treatments.length - 1) const Padding(padding: EdgeInsets.only(bottom: 8)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightMQ = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: _treatmentsViewmodel,
      builder: (context, child) {
        return EZTPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _treatmentsViewmodel.fetch,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                if (_treatmentsViewmodel.treatments.isNotEmpty && _treatmentsViewmodel.state != StateEnum.loading)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.treatmentsFound(_treatmentsViewmodel.treatments.length),
                        style: TextStyles(context).link(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                Expanded(child: _buildTreatmentsList(heightMQ)),
              ],
            ),
          ),
        );
      },
    );
  }
}
