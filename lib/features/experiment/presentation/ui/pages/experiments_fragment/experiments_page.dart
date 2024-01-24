// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../core/routing/routing.dart';
import '../../../../../../shared/extensions/context_theme_mode_extensions.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../main/presentation/viewmodel/home_viewmodel.dart';
import '../../../viewmodel/experiments_viewmodel.dart';
import '../../widgets/experiment_card.dart';
import '../../widgets/experiment_exclusion_dialog.dart';
import '../../widgets/experiment_filter_dialog.dart';

class ExperimentsPage extends StatefulWidget {
  const ExperimentsPage({
    super.key,
  });

  @override
  State<ExperimentsPage> createState() => _ExperimentsPageState();
}

class _ExperimentsPageState extends State<ExperimentsPage> {
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final HomeViewmodel _homeViewmodel;
  final Key _refreshIndicatorKey = GlobalKey();

  List<bool> isSelected = [true, false];

  int selectedButtonSegment = 0;

  @override
  void initState() {
    super.initState();
    _experimentsViewmodel = GetIt.I.get<ExperimentsViewmodel>();
    _homeViewmodel = GetIt.I.get<HomeViewmodel>();

    _experimentsViewmodel.scrollController.addListener(() {
      if (_experimentsViewmodel.scrollController.position.pixels >
              _experimentsViewmodel.scrollController.position.maxScrollExtent -
                  200 &&
          _experimentsViewmodel.hasNextPage) {
        if (_experimentsViewmodel.state != StateEnum.loading) {
          _experimentsViewmodel.fetch(pagination: _experimentsViewmodel.page);
        }
      }
    });

    if (mounted) {
      _experimentsViewmodel.addListener(
        () async {
          if (_experimentsViewmodel.state == StateEnum.error && mounted) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              HandleFailure.of(_experimentsViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
            if (_experimentsViewmodel.failure
                    is ExpiredTokenOrWrongUserFailure ||
                _experimentsViewmodel.failure
                    is UserNotFoundOrWrongTokenFailure ||
                _experimentsViewmodel.failure is SessionNotFoundFailure) {
              _homeViewmodel.accountViewmodel.logout();

              if (_homeViewmodel.accountViewmodel.state == StateEnum.success &&
                  mounted) {
                EZTSnackBar.show(
                  context,
                  "Faça seu login novamente.",
                );
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) {
                  Navigator.pushReplacementNamed(context, Routing.login);
                  GetIt.I.get<HomeViewmodel>().setFragmentIndex(0);
                }
              }
            }
          }
        },
      );
    }
  }

  Future<void> _showFiltersDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ExperimentFilterDialog();
      },
    );
  }

  Widget _buildExperimentsList(double height) {
    if (_experimentsViewmodel.state == StateEnum.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar experimentos',
        ),
      );
    }

    if (_experimentsViewmodel.state == StateEnum.loading &&
        _experimentsViewmodel.isLoadingMoreRunning == false) {
      return const EZTProgressIndicator(
        message: "Carregando experimentos...",
      );
    }

    if (_experimentsViewmodel.state == StateEnum.success &&
        _experimentsViewmodel.experiments.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message: "Experimentos não encontrados",
        ),
      );
    }

    return ListView.builder(
      key: PageStorageKey(_homeViewmodel.fragmentIndex),
      controller: _experimentsViewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: _experimentsViewmodel.experiments.length + 1,
      itemBuilder: (context, index) {
        if (index < _experimentsViewmodel.experiments.length) {
          var experiment = _experimentsViewmodel.experiments[index];

          return Column(
            children: [
              Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) async {
                  setState(() {
                    _experimentsViewmodel.experiments.removeAt(index);
                  });

                  EZTSnackBar.clear(context);

                  bool permanentlyDeleted = true;

                  EZTSnackBar.show(
                    context,
                    '${experiment.name} excluído!',
                    eztSnackBarType: EZTSnackBarType.error,
                    action: SnackBarAction(
                      label: 'Desfazer',
                      textColor: context.getApplyedColorScheme.onError,
                      onPressed: () {
                        setState(() {
                          _experimentsViewmodel.experiments
                              .insert(index, experiment);
                          permanentlyDeleted = false;
                        });
                      },
                    ),
                    onDismissFunction: () async {
                      if (permanentlyDeleted) {
                        await _experimentsViewmodel
                            .deleteExperiment(experiment.id);
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
                          'Excluir',
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
                    _homeViewmodel.accountViewmodel.enableExcludeConfirmation!
                        ? (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const ExperimentExclusionDialog();
                              },
                            );
                          }
                        : null,
                child: ExperimentCard(
                  experiment: experiment,
                  indexOfExperiment: index + 1,
                ),
              ),
              if (_experimentsViewmodel.isLoadingMoreRunning == false &&
                  _experimentsViewmodel.hasNextPage == true &&
                  index == _experimentsViewmodel.experiments.length - 1)
                SizedBox(height: height / 7),
            ],
          );
        } else {
          return Column(
            children: [
              if (_experimentsViewmodel.isLoadingMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (_experimentsViewmodel.hasNextPage == false &&
                  _experimentsViewmodel.state == StateEnum.success)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 16),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    color: context.getApplyedColorScheme.tertiaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                        child: Text(
                          'Todos os experimentos exibidos!',
                          style: TextStyles(context).buttonPrimary.copyWith(
                                color: context.getApplyedColorScheme.tertiary,
                                fontSize: 20.0,
                              ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  String get isPlural =>
      _experimentsViewmodel.totalOfExperiments > 1 ? 's ' : ' ';

  @override
  Widget build(BuildContext context) {
    var heightMQ = MediaQuery.of(context).size.height;

    return ListenableBuilder(
      listenable: _experimentsViewmodel,
      builder: (context, child) {
        return AbsorbPointer(
          absorbing: _experimentsViewmodel.scrollController.hasClients
              ? _experimentsViewmodel.state == StateEnum.loading &&
                  _experimentsViewmodel
                          .scrollController.position.maxScrollExtent ==
                      _experimentsViewmodel.scrollController.offset
              : _experimentsViewmodel.state == StateEnum.loading,
          child: EZTPullToRefresh(
            key: _refreshIndicatorKey,
            onRefresh: () {
              return _experimentsViewmodel.fetch();
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SegmentedButton(
                        emptySelectionAllowed: false,
                        showSelectedIcon: false,
                        segments: <ButtonSegment<int>>[
                          ButtonSegment<int>(
                            value: 0,
                            label: const Text('Em andamento'),
                            icon: Icon(
                              PhosphorIcons.clockClockwise(),
                            ),
                          ),
                          ButtonSegment<int>(
                            value: 1,
                            label: const Text('Concluído'),
                            icon: Icon(PhosphorIcons.checks()),
                          ),
                        ],
                        selected: <int>{selectedButtonSegment},
                        onSelectionChanged: (Set<int> newSelection) {
                          setState(() {
                            selectedButtonSegment = newSelection.first;
                            if (selectedButtonSegment == 0) {
                              if (_experimentsViewmodel.finishedFilter !=
                                  false) {
                                _experimentsViewmodel.setFinishedFilter(false);
                                _experimentsViewmodel.fetch();
                                return;
                              }

                              return;
                            }

                            if (_experimentsViewmodel.finishedFilter ||
                                !_homeViewmodel.hasInternetConnection) return;

                            _experimentsViewmodel.setFinishedFilter(true);
                            _experimentsViewmodel.fetch();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          _experimentsViewmodel.anyFilterIsEnabled()
                              ? PhosphorIcons.funnel(PhosphorIconsStyle.fill)
                              : PhosphorIcons.funnel(),
                          color: _experimentsViewmodel.anyFilterIsEnabled()
                              ? context.getApplyedColorScheme.primary
                              : null,
                        ),
                        onPressed: _showFiltersDialog,
                      ),
                    ],
                  ),
                ),
                if (_experimentsViewmodel.experiments.isNotEmpty)
                  Text(
                    "🔬 ${_experimentsViewmodel.totalOfExperiments} experimento${isPlural}encontrado$isPlural",
                    style: TextStyles(context).link(fontSize: 16),
                  ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: _buildExperimentsList(heightMQ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
