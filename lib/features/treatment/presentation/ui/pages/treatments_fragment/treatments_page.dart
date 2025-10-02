// 🐦 Flutter imports:
import 'dart:convert';

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../l10n/app_localizations.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../main/presentation/viewmodel/settings_viewmodel.dart';
import '../../../viewmodel/treatments_viewmodel.dart';
import '../../widgets/treatment_card.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({
    super.key,
  });

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
      final l10n = AppLocalizations.of(context)!;
      _treatmentsViewmodel.addListener(
        () {
          if (mounted && _treatmentsViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(l10n, _treatmentsViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  Widget _buildTreatmentsList(double height) {
    final l10n = AppLocalizations.of(context)!;
    if (_treatmentsViewmodel.state == StateEnum.error) {
      return EZTForcedCenter(
        child: EZTError(
          message: l10n.errorLoadingTreatments,
        ),
      );
    }

    if (_treatmentsViewmodel.state == StateEnum.loading) {
      return EZTProgressIndicator(
        message: l10n.loadingTreatments,
      );
    }

    if (_treatmentsViewmodel.state == StateEnum.success &&
        _treatmentsViewmodel.treatments.isEmpty) {
      return EZTForcedCenter(
        child: EZTNotFound(
          message: l10n.treatmentsNotFound,
        ),
      );
    }

    return ListView.builder(
      controller: _treatmentsViewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
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
                  l10n.treatmentDeleted(treatment.name),
                  eztSnackBarType: EZTSnackBarType.error,
                  action: SnackBarAction(
                    label: l10n.undo,
                    textColor: context.getApplyedColorScheme.onError,
                    onPressed: () {
                      setState(() {
                        _treatmentsViewmodel.treatments
                            .insert(index, treatment);
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
                      Icon(
                        PhosphorIcons.trash(PhosphorIconsStyle.light),
                        color: context.getApplyedColorScheme.onError,
                      ),
                      Text(
                        l10n.delete,
                        style: TextStyle(
                          color: context.getApplyedColorScheme.onError,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss:
                  GetIt.I.get<SettingsViewmodel>().enableExcludeConfirmation!
                      ? (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(l10n.deleteTreatmentTitle),
                                content: Text(l10n.deleteTreatmentContent),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: Text(l10n.deleteButton)),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text(l10n.cancelButton),
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
            if (index == _treatmentsViewmodel.treatments.length - 1)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
              )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  if (_treatmentsViewmodel.treatments.isNotEmpty &&
                      _treatmentsViewmodel.state != StateEnum.loading)
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          l10n.treatmentsFound(
                            _treatmentsViewmodel.treatments.length
                          ),
                          style: TextStyles(context).link(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  Expanded(
                    child: _buildTreatmentsList(heightMQ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
