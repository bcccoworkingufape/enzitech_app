// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/components/experiment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/components/experiment_filter_dialog.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_error.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_forced_center.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_not_found.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_progress_indicator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_pull_to_refresh.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class ExperimentsPage extends StatefulWidget {
  const ExperimentsPage({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  final HomeController homeController;
  @override
  State<ExperimentsPage> createState() => _ExperimentsPageState();
}

class _ExperimentsPageState extends State<ExperimentsPage> {
  late final ExperimentsController controller;
  final Key _refreshIndicatorKey = GlobalKey();

  // final _searchTermController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentsController>();

    controller.scrollController.addListener(() {
      if (controller.scrollController.position.pixels >
              controller.scrollController.position.maxScrollExtent - 200 &&
          controller.hasNextPage) {
        if (controller.state != ExperimentsState.loading) {
          controller.loadExperiments(controller.page);
        }
      }
    });

    if (mounted) {
      controller.addListener(
        () async {
          if (controller.state == ExperimentsState.error && mounted) {
            EZTSnackBar.clear(context);
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
            var accountController = context.read<AccountController>();
            if (controller.failure is ExpiredTokenOrWrongUserFailure ||
                controller.failure is UserNotFoundOrWrongTokenFailure ||
                controller.failure is SessionNotFoundFailure) {
              accountController.logout();

              if (accountController.state == AccountState.success && mounted) {
                EZTSnackBar.show(
                  context,
                  "Faça seu login novamente.",
                );
                await Future.delayed(const Duration(milliseconds: 500));
                if (mounted) {
                  Navigator.pushReplacementNamed(context, RouteGenerator.auth);
                  widget.homeController.setFragmentIndex(0);
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
      controller: _searchTermController,
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
    if (controller.state == ExperimentsState.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar experimentos',
        ),
      );
    }

    if (controller.state == ExperimentsState.loading &&
        controller.isLoadingMoreRunning == false) {
      return const EZTProgressIndicator(
        message: "Carregando experimentos...",
      );
    }

    if (controller.state == ExperimentsState.success &&
        controller.experiments.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message: "Experimentos não encontrados",
        ),
      );
    }

    return ListView.builder(
      key: PageStorageKey(widget.homeController.fragmentIndex),
      controller: controller.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.experiments.length + 1,
      itemBuilder: (context, index) {
        if (index < controller.experiments.length) {
          var experiment = controller.experiments[index];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    // Remove the item from the data source.
                    setState(() {
                      controller.experiments.removeAt(index);
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
                            controller.experiments.insert(index, experiment);
                            permanentlyDeleted = false;
                          });
                          // todoRepository.saveTodoList(todos);
                        },
                      ),
                      onDismissFunction: () async {
                        if (permanentlyDeleted) {
                          await controller.deleteExperiment(experiment.id);
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
                  confirmDismiss: widget.homeController.accountController
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
              if (controller.isLoadingMoreRunning == false &&
                  controller.hasNextPage == true &&
                  index == controller.experiments.length - 1)
                SizedBox(height: height / 7),
            ],
          );
        } else {
          return Column(
            children: [
              if (controller.isLoadingMoreRunning == true)
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (controller.hasNextPage == false &&
                  controller.state == ExperimentsState.success)
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
    final controller = context.watch<ExperimentsController>();

    return AbsorbPointer(
      absorbing: controller.scrollController.hasClients
          ? controller.state == ExperimentsState.loading &&
              controller.scrollController.position.maxScrollExtent ==
                  controller.scrollController.offset
          : controller.state == ExperimentsState.loading,
      child: EZTPullToRefresh(
        key: _refreshIndicatorKey,
        onRefresh: () {
          // controller.setFinishedFilter(false);
          return controller.loadExperiments(1);
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
                      initialLabelIndex: controller.finishedFilter ? 1 : 0,
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
                          if (controller.finishedFilter != false) {
                            controller.setFinishedFilter(false);
                            controller.loadExperiments(1);
                            return;
                          }

                          return;
                        }

                        if (controller.finishedFilter) return;

                        controller.setFinishedFilter(true);
                        controller.loadExperiments(1);
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
                            controller.anyFilterIsEnabled()
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
              if (controller.experiments.isNotEmpty)
                Text(
                  "🔬 ${controller.totalOfExperiments} experimento${controller.experiments.length > 1 ? 's ' : ' '}encontrado${controller.experiments.length > 1 ? 's ' : ' '}",
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
