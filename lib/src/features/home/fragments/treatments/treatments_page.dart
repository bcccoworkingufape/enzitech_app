// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/components/treatment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_error.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_forced_center.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_not_found.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_progress_indicator.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_pull_to_refresh.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  final HomeController homeController;

  @override
  State<TreatmentsPage> createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  late final TreatmentsController controller;
  final Key _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = context.read<TreatmentsController>();
    if (mounted) {
      controller.addListener(
        () {
          if (mounted && controller.state == TreatmentsState.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(controller.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  Widget _buildTreatmentsList(double height) {
    if (controller.state == TreatmentsState.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar tratamentos',
        ),
      );
    }

    if (controller.state == TreatmentsState.loading) {
      return const EZTProgressIndicator(
        message: "Carregando tratamentos...",
      );
    }

    if (controller.state == TreatmentsState.success &&
        controller.treatments.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message: "Tratamentos não encontrados",
        ),
      );
    }

    return ListView.builder(
      controller: controller.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.treatments.length,
      itemBuilder: (context, index) {
        var treatment = controller.treatments[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Dismissible(
                key: Key(treatment.id),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    controller.treatments.removeAt(index);
                  });

                  EZTSnackBar.clear(context);

                  bool permanentlyDeleted = true;

                  EZTSnackBar.show(
                    context,
                    '${treatment.name} excluído!',
                    eztSnackBarType: EZTSnackBarType.error,
                    action: SnackBarAction(
                      label: 'Desfazer',
                      textColor: AppColors.white,
                      onPressed: () {
                        setState(() {
                          controller.treatments.insert(index, treatment);
                          permanentlyDeleted = false;
                        });
                        // todoRepository.saveTodoList(todos);
                      },
                    ),
                    onDismissFunction: () async {
                      if (permanentlyDeleted) {
                        await controller.deleteTreatment(treatment.id);
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
                    context.read<AccountController>().enableExcludeConfirmation!
                        ? (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Excluir o tratamento?'),
                                  content: const Text(
                                      'Você tem certeza que deseja excluir este tratamento?'),
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TreatmentCard(
                    name: treatment.name,
                    createdAt: treatment.createdAt!,
                    description: treatment.description,
                  ),
                ),
              ),
            ),
            if (index == controller.treatments.length - 1)
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
    var heightMQ = MediaQuery.of(context).size.height;
    final controller = context.watch<TreatmentsController>();

    return EZTPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: controller.loadTreatments,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (controller.treatments.isNotEmpty &&
                controller.state != TreatmentsState.loading)
              Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "🧪 ${controller.treatments.length} tratamento${controller.treatments.length > 1 ? 's ' : ' '}encontrado${controller.treatments.length > 1 ? 's ' : ' '}",
                    style: TextStyles.link.copyWith(fontSize: 16),
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
  }
}
