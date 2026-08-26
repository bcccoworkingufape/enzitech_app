// 🐦 Flutter imports:

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
import '../../../../domain/entities/enzyme_entity.dart';
import '../../../viewmodel/enzymes_viewmodel.dart';
import '../../widgets/enzyme_card.dart';
import '../../widgets/enzymes_summary.dart';

class EnzymesPage extends StatefulWidget {
  const EnzymesPage({super.key});

  @override
  State<EnzymesPage> createState() => _EnzymesPageState();
}

class _EnzymesPageState extends State<EnzymesPage> {
  late final SettingsViewmodel _accountViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;

  final Key _refreshIndicatorKey = GlobalKey();

  Widget getEnzymeCard(EnzymeEntity enzyme) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: EnzymeCard(enzyme: enzyme),
    );
  }

  @override
  void initState() {
    super.initState();
    _accountViewmodel = GetIt.I.get<SettingsViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();

    if (mounted) {
      _enzymesViewmodel.addListener(() {
        if (mounted && _enzymesViewmodel.state == StateEnum.error) {
          EZTSnackBar.show(
            context,
            HandleFailure.of(context.l10n, _enzymesViewmodel.failure!),
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

  Widget _buildEnzymesList(double height) {
    if (_enzymesViewmodel.state == StateEnum.error) {
      return EZTForcedCenter(child: EZTError(message: context.l10n.errorLoadingEnzymes));
    }

    if (_enzymesViewmodel.state == StateEnum.loading) {
      return EZTProgressIndicator(message: context.l10n.loadingEnzymes);
    }

    if (_enzymesViewmodel.state == StateEnum.success && _enzymesViewmodel.enzymes.isEmpty) {
      return EZTForcedCenter(
        child: EZTNotFound(
          message: _accountViewmodel.user!.userType == UserTypeEnum.admin
              ? context.l10n.noEnzymesRegisteredAdmin
              : context.l10n.noEnzymesRegisteredUser,
        ),
      );
    }

    return ListView.builder(
      controller: _enzymesViewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: _enzymesViewmodel.enzymes.length,
      itemBuilder: (context, index) {
        var enzyme = _enzymesViewmodel.enzymes[index];
        return Column(
          children: [
            Visibility(
              visible: _accountViewmodel.user!.userType == UserTypeEnum.user,
              replacement: Dismissible(
                key: Key(enzyme.id),
                onDismissed: (direction) {
                  setState(() {
                    _enzymesViewmodel.enzymes.removeAt(index);
                  });

                  EZTSnackBar.clear(context);

                  bool permanentlyDeleted = true;

                  EZTSnackBar.show(
                    context,
                    context.l10n.enzymeDeleted(enzyme.name),
                    eztSnackBarType: EZTSnackBarType.error,
                    action: SnackBarAction(
                      label: context.l10n.undo,
                      textColor: context.getApplyedColorScheme.onError,
                      onPressed: () {
                        setState(() {
                          _enzymesViewmodel.enzymes.insert(index, enzyme);
                          permanentlyDeleted = false;
                        });
                      },
                    ),
                    onDismissFunction: () async {
                      if (permanentlyDeleted) {
                        await _enzymesViewmodel.deleteEnzyme(enzyme.id);
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
                          context.l10n.delete,
                          style: TextStyle(color: context.getApplyedColorScheme.onError),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: _accountViewmodel.enableExcludeConfirmation!
                    ? (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(context.l10n.deleteEnzymeTitle),
                              content: Text(context.l10n.deleteEnzymeContent),
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
                child: getEnzymeCard(enzyme),
              ),
              child: Padding(padding: const EdgeInsets.only(bottom: 8.0), child: getEnzymeCard(enzyme)),
            ),
            if (index == _enzymesViewmodel.enzymes.length - 1) const Padding(padding: EdgeInsets.only(bottom: 8)),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var heightMQ = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: _enzymesViewmodel,
      builder: (context, child) {
        return EZTPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _enzymesViewmodel.fetch,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
            child: Column(
              children: [
                if (_enzymesViewmodel.enzymes.isNotEmpty && _enzymesViewmodel.state != StateEnum.loading)
                  Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        context.l10n.enzymesFound(_enzymesViewmodel.enzymes.length),
                        style: TextStyles(context).link(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      const EnzymesSummary(),
                      const SizedBox(height: 8),
                    ],
                  ),
                Expanded(child: _buildEnzymesList(heightMQ)),
              ],
            ),
          ),
        );
      },
    );
  }
}
