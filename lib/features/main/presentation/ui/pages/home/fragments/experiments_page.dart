// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

// 🌎 Project imports:
import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/failures/failures.dart';
import '../../../../../../../core/routing/routing.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../viewmodel/fragments/experiments_viewmodel.dart';
import '../../../../viewmodel/home_viewmodel.dart';
import '../../../widgets/experiment_card.dart';
import '../../../widgets/experiment_filter_dialog.dart';

class ExperimentsPage extends StatefulWidget {
  const ExperimentsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExperimentsPage> createState() => _ExperimentsPageState();
}

class _ExperimentsPageState extends State<ExperimentsPage> {
  late final ExperimentsViewmodel _experimentsViewmodel;
  late final HomeViewmodel _homeViewmodel;
  final Key _refreshIndicatorKey = GlobalKey();

  // final _searchTermController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];

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
            // var accountViewmodel = context.read<AccountViewmodel>();
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

  /* Widget get _searchTermInput {
    final validations = <ValidateRule>[
      ValidateRule(
        ValidateTypes.name,
      ),
    ];

    final fieldValidator = FieldValidator(validations, context);

    return EZTTextField(
      viewmodel: _searchTermController,
      lineHeight: 1.8,
      eztTextFieldType: EZTTextFieldType.underline,
      hintText: "Pesquisar experimento",
      usePrimaryColorOnFocusedBorder: true,
      keyboardType: TextInputType.name,
      suffixIcon: const Icon(
        PhosphorIcons.magnifyingGlass,
        color: AppColors.primary,
        size: 35,
      ),
      fieldValidator: fieldValidator,
    );
  } */

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
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    // Remove the item from the data source.
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
                        textColor: AppColors.white,
                        onPressed: () {
                          setState(() {
                            _experimentsViewmodel.experiments
                                .insert(index, experiment);
                            permanentlyDeleted = false;
                          });
                          // todoRepository.saveTodoList(todos);
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
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Icon(
                            PhosphorIcons.trashLight,
                            color: Colors.white,
                          ),
                          Text(
                            'Excluir',
                            style: TextStyle(color: Colors.white),
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
                                  return AlertDialog(
                                    title: const Text('Excluir o experimento?'),
                                    content: const Text(
                                        'Você tem certeza que deseja excluir este experimento?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("EXCLUIR")),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCELAR"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          : null,
                  child: ExperimentCard(
                    experiment: experiment,
                    indexOfExperiment: index + 1,
                  ),
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
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 4,
                    shadowColor: AppColors.white,
                    color: AppColors.yellow,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                        child: Text(
                          'Todos os experimentos exibidos!',
                          style: TextStyles.buttonPrimary.copyWith(
                            color: AppColors.greySweet,
                            fontSize: 20,
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

  @override
  Widget build(BuildContext context) {
    var widthMQ = MediaQuery.of(context).size.width;
    var heightMQ = MediaQuery.of(context).size.height;

    return AbsorbPointer(
      absorbing: _experimentsViewmodel.scrollController.hasClients
          ? _experimentsViewmodel.state == StateEnum.loading &&
              _experimentsViewmodel.scrollController.position.maxScrollExtent ==
                  _experimentsViewmodel.scrollController.offset
          : _experimentsViewmodel.state == StateEnum.loading,
      child: EZTPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: () {
          // _experimentsViewmodel.setFinishedFilter(false);
          return _experimentsViewmodel.fetch();
        },
        child: AnimatedBuilder(
          animation: _experimentsViewmodel,
          builder: (context, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: _searchTermInput,
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        ToggleSwitch(
                          initialLabelIndex:
                              _experimentsViewmodel.finishedFilter ? 1 : 0,
                          minWidth: (widthMQ * 0.4),
                          totalSwitches: 2,
                          labels: const ['Em andamento', 'Concluído'],
                          activeFgColor: AppColors.white,
                          inactiveFgColor: AppColors.primary,
                          activeBgColor: const [AppColors.primary],
                          inactiveBgColor: AppColors.white,
                          borderColor: const [AppColors.primary],
                          borderWidth: 1.5,
                          onToggle: (index) {
                            if (index == 0) {
                              if (_experimentsViewmodel.finishedFilter !=
                                  false) {
                                _experimentsViewmodel.setFinishedFilter(false);
                                _experimentsViewmodel.fetch();
                                return;
                              }

                              return;
                            }

                            if (_experimentsViewmodel.finishedFilter) return;

                            _experimentsViewmodel.setFinishedFilter(true);
                            _experimentsViewmodel.fetch();
                          },
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            onTap: _showFiltersDialog,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Icon(
                                _experimentsViewmodel.anyFilterIsEnabled()
                                    ? PhosphorIcons.funnelFill
                                    : PhosphorIcons.funnel,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  if (_experimentsViewmodel.experiments.isNotEmpty)
                    Text(
                      "🔬 ${_experimentsViewmodel.totalOfExperiments} experimento${_experimentsViewmodel.experiments.length > 1 ? 's ' : ' '}encontrado${_experimentsViewmodel.experiments.length > 1 ? 's ' : ' '}",
                      style: TextStyles.link.copyWith(fontSize: 16),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Expanded(
                    child: _buildExperimentsList(heightMQ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
