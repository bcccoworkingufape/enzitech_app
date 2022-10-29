// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/ui/fragments/account/viewmodel/account_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/ui/components/experiment_card.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/ui/components/experiment_filter_dialog.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class ExperimentsPage extends StatefulWidget {
  const ExperimentsPage({
    Key? key,
    required this.homeViewmodel,
  }) : super(key: key);

  final HomeViewmodel homeViewmodel;
  @override
  State<ExperimentsPage> createState() => _ExperimentsPageState();
}

class _ExperimentsPageState extends State<ExperimentsPage> {
  late final ExperimentsViewmodel viewmodel;
  final Key _refreshIndicatorKey = GlobalKey();

  // final _searchTermController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    viewmodel = context.read<ExperimentsViewmodel>();

    viewmodel.scrollController.addListener(() {
      if (viewmodel.scrollController.position.pixels >
              viewmodel.scrollController.position.maxScrollExtent - 200 &&
          viewmodel.hasNextPage) {
        if (viewmodel.state != StateEnum.loading) {
          viewmodel.loadExperiments(viewmodel.page);
        }
      }
    });

    if (mounted) {
      viewmodel.addListener(
        () async {
          if (viewmodel.state == StateEnum.error && mounted) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              HandleFailure.of(viewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
            var accountViewmodel = context.read<AccountViewmodel>();
            if (viewmodel.failure is ExpiredTokenOrWrongUserFailure ||
                viewmodel.failure is UserNotFoundOrWrongTokenFailure ||
                viewmodel.failure is SessionNotFoundFailure) {
              accountViewmodel.logout();

              if (accountViewmodel.state == StateEnum.success && mounted) {
                EZTSnackBar.show(
                  context,
                  "Faça seu login novamente.",
                );
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) {
                  Navigator.pushReplacementNamed(context, RouteGenerator.auth);
                  widget.homeViewmodel.setFragmentIndex(0);
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
    if (viewmodel.state == StateEnum.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar experimentos',
        ),
      );
    }

    if (viewmodel.state == StateEnum.loading &&
        viewmodel.isLoadingMoreRunning == false) {
      return const EZTProgressIndicator(
        message: "Carregando experimentos...",
      );
    }

    if (viewmodel.state == StateEnum.success && viewmodel.experiments.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message: "Experimentos não encontrados",
        ),
      );
    }

    return ListView.builder(
      key: PageStorageKey(widget.homeViewmodel.fragmentIndex),
      controller: viewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: viewmodel.experiments.length + 1,
      itemBuilder: (context, index) {
        if (index < viewmodel.experiments.length) {
          var experiment = viewmodel.experiments[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    // Remove the item from the data source.
                    setState(() {
                      viewmodel.experiments.removeAt(index);
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
                            viewmodel.experiments.insert(index, experiment);
                            permanentlyDeleted = false;
                          });
                          // todoRepository.saveTodoList(todos);
                        },
                      ),
                      onDismissFunction: () async {
                        if (permanentlyDeleted) {
                          await viewmodel.deleteExperiment(experiment.id);
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
                  confirmDismiss: widget.homeViewmodel.accountViewmodel
                          .enableExcludeConfirmation!
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
              if (viewmodel.isLoadingMoreRunning == false &&
                  viewmodel.hasNextPage == true &&
                  index == viewmodel.experiments.length - 1)
                SizedBox(height: height / 7),
            ],
          );
        } else {
          return Column(
            children: [
              if (viewmodel.isLoadingMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (viewmodel.hasNextPage == false &&
                  viewmodel.state == StateEnum.success)
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
    final viewmodel = context.watch<ExperimentsViewmodel>();

    return AbsorbPointer(
      absorbing: viewmodel.scrollController.hasClients
          ? viewmodel.state == StateEnum.loading &&
              viewmodel.scrollController.position.maxScrollExtent ==
                  viewmodel.scrollController.offset
          : viewmodel.state == StateEnum.loading,
      child: EZTPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: () {
          // viewmodel.setFinishedFilter(false);
          return viewmodel.loadExperiments(1);
        },
        child: Padding(
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
                      initialLabelIndex: viewmodel.finishedFilter ? 1 : 0,
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
                          if (viewmodel.finishedFilter != false) {
                            viewmodel.setFinishedFilter(false);
                            viewmodel.loadExperiments(1);
                            return;
                          }

                          return;
                        }

                        if (viewmodel.finishedFilter) return;

                        viewmodel.setFinishedFilter(true);
                        viewmodel.loadExperiments(1);
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
                            viewmodel.anyFilterIsEnabled()
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
              if (viewmodel.experiments.isNotEmpty)
                Text(
                  "🔬 ${viewmodel.totalOfExperiments} experimento${viewmodel.experiments.length > 1 ? 's ' : ' '}encontrado${viewmodel.experiments.length > 1 ? 's ' : ' '}",
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
        ),
      ),
    );
  }
}
