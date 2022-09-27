// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/components/experiment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/validator/validator.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_pull_to_refresh.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_textfield.dart';

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
  late ScrollController scrollController;
  final Key _refreshIndicatorKey = GlobalKey();

  final _searchTermController = TextEditingController(text: '');
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    controller = context.read<ExperimentsController>();
    scrollController = ScrollController()
      ..addListener(() {
        if (scrollController.position.maxScrollExtent ==
                scrollController.offset &&
            controller.hasNextPage) {
          controller.loadExperiments(controller.page);
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

  Widget get _searchTermInput {
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
  }

  Widget _buildExperimentsList(double height) {
    if (controller.state == ExperimentsState.error) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.75,
              child: const Center(
                child: Text("Erro ao carregar experimentos"),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.state == ExperimentsState.loading &&
        controller.isLoadingMoreRunning == false) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state == ExperimentsState.success &&
        controller.experiments.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.75,
              child: const Center(
                child: Text("Experimentos não encontrados"),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
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
                  key: Key(experiment.id),
                  onDismissed: (direction) async {
                    await controller.deleteExperiment(experiment.id);

                    // Remove the item from the data source.
                    setState(() {
                      controller.experiments.removeAt(index);
                    });

                    if (mounted) {
                      EZTSnackBar.clear(context);

                      EZTSnackBar.show(
                        context,
                        '${experiment.name} excluído!',
                        eztSnackBarType: EZTSnackBarType.error,
                      );
                    }
                  },
                  // Show a red background as the item is swiped away.
                  background: Container(color: Colors.red),
                  child: ExperimentCard(
                    experiment: experiment,
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
                  padding: EdgeInsets.only(top: 10, bottom: 40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              if (controller.hasNextPage == false &&
                  controller.state == ExperimentsState.success)
                Card(
                  elevation: 4,
                  shadowColor: AppColors.white,
                  color: AppColors.yellow300,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Center(
                      child: Text(
                        'Todos os experimentos exibidos!',
                        style: TextStyles.buttonPrimary.copyWith(
                          color: AppColors.greyMedium,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              if (controller.isLoadingMoreRunning == false &&
                  controller.hasNextPage == false)
                SizedBox(height: height / 13),
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

    return EZTPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: () => controller.loadExperiments(1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: _searchTermInput,
            ),
            const SizedBox(
              height: 16,
            ),
            ToggleSwitch(
              minWidth: widthMQ,
              totalSwitches: 2,
              labels: const ['Em andamento', 'Concluído'],
              activeFgColor: AppColors.white,
              inactiveFgColor: AppColors.primary,
              activeBgColor: const [AppColors.primary],
              inactiveBgColor: AppColors.white,
              borderColor: const [AppColors.primary],
              borderWidth: 1.5,
              onToggle: (index) {
                print(index);
                // call controller to update search when this changes
              },
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
  }
}
