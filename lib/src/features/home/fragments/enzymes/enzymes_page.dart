// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/components/enzyme_card.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/components/enzymes_summary.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/user_type_enum.dart';
import 'package:enzitech_app/src/shared/business/infra/models/user_model.dart';
import 'package:enzitech_app/src/shared/models_/enzyme_model.dart';
import 'package:enzitech_app/src/shared/ui/themes/themes.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_error.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_forced_center.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_not_found.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_progress_indicator.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_pull_to_refresh.dart';
import 'package:enzitech_app/src/shared/ui/widgets/ezt_snack_bar.dart';
import 'package:enzitech_app/src/shared/utilities/failures/failures.dart';

class EnzymesPage extends StatefulWidget {
  const EnzymesPage({
    Key? key,
    required this.homeController,
  }) : super(key: key);

  final HomeController homeController;

  @override
  State<EnzymesPage> createState() => _EnzymesPageState();
}

class _EnzymesPageState extends State<EnzymesPage> {
  late final EnzymesController controller;
  late final AccountController accountController;

  final Key _refreshIndicatorKey = GlobalKey();

  Widget getEnzymeCard(EnzymeModel enzyme) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: EnzymeCard(
        enzyme: enzyme,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = context.read<EnzymesController>();
    accountController = context.read<AccountController>();

    if (mounted) {
      controller.addListener(
        () {
          if (mounted && controller.state == EnzymesState.error) {
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

  Widget _buildEnzymesList(double height) {
    if (controller.state == EnzymesState.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar enzimas',
        ),
      );
    }

    if (controller.state == EnzymesState.loading) {
      return const EZTProgressIndicator(
        message: "Carregando enzimas...",
      );
    }

    if (controller.state == EnzymesState.success &&
        controller.enzymes.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message:
              "Nenhuma enzima cadastrada, entre em contato com o seu Administrador para solucionar este problema.",
        ),
      );
    }

    return ListView.builder(
      controller: controller.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: controller.enzymes.length,
      itemBuilder: (context, index) {
        var enzyme = controller.enzymes[index];
        return Column(
          children: [
            Visibility(
              visible: accountController.user!.userType == UserTypeEnum.user,
              replacement: Dismissible(
                key: Key(enzyme.id),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    controller.enzymes.removeAt(index);
                  });

                  EZTSnackBar.clear(context);

                  bool permanentlyDeleted = true;

                  EZTSnackBar.show(
                    context,
                    '${enzyme.name} excluído!',
                    eztSnackBarType: EZTSnackBarType.error,
                    action: SnackBarAction(
                      label: 'Desfazer',
                      textColor: AppColors.white,
                      onPressed: () {
                        setState(() {
                          controller.enzymes.insert(index, enzyme);
                          permanentlyDeleted = false;
                        });
                        // todoRepository.saveTodoList(todos);
                      },
                    ),
                    onDismissFunction: () async {
                      if (permanentlyDeleted) {
                        await controller.deleteEnzyme(enzyme.id);
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
                                  title: const Text('Excluir a enzima?'),
                                  content: const Text(
                                      'Você tem certeza que deseja excluir esta enzima?'),
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
                child: getEnzymeCard(enzyme),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: getEnzymeCard(enzyme),
              ),
            ),
            if (index == controller.enzymes.length - 1)
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
    final controller = context.watch<EnzymesController>();

    return EZTPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: controller.loadEnzymes,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (controller.enzymes.isNotEmpty &&
                controller.state != EnzymesState.loading)
              Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "🧬 ${controller.enzymes.length} enzima${controller.enzymes.length > 1 ? 's ' : ' '}encontrada${controller.enzymes.length > 1 ? 's ' : ' '}",
                    style: TextStyles.link.copyWith(fontSize: 16),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const EnzymesSummary(),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            Expanded(
              child: _buildEnzymesList(heightMQ),
            ),
          ],
        ),
      ),
    );
  }
}
