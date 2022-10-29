// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/ui/fragments/account/viewmodel/account_viewmodel.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/enzymes/ui/components/enzyme_card.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/enzymes/ui/components/enzymes_summary.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/enzymes/viewmodel/enzymes_viewmodel.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class EnzymesPage extends StatefulWidget {
  const EnzymesPage({
    Key? key,
    required this.homeViewmodel,
  }) : super(key: key);

  final HomeViewmodel homeViewmodel;

  @override
  State<EnzymesPage> createState() => _EnzymesPageState();
}

class _EnzymesPageState extends State<EnzymesPage> {
  late final AccountViewmodel accountViewmodel;
  late final EnzymesViewmodel viewmodel;

  final Key _refreshIndicatorKey = GlobalKey();

  Widget getEnzymeCard(EnzymeEntity enzyme) {
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
    accountViewmodel = context.read<AccountViewmodel>();
    viewmodel = context.read<EnzymesViewmodel>();

    if (mounted) {
      viewmodel.addListener(
        () {
          if (mounted && viewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(viewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  Widget _buildEnzymesList(double height) {
    if (viewmodel.state == StateEnum.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar enzimas',
        ),
      );
    }

    if (viewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(
        message: "Carregando enzimas...",
      );
    }

    if (viewmodel.state == StateEnum.success && viewmodel.enzymes.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message:
              "Nenhuma enzima cadastrada, entre em contato com o seu Administrador para solucionar este problema.",
        ),
      );
    }

    return ListView.builder(
      controller: viewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: viewmodel.enzymes.length,
      itemBuilder: (context, index) {
        var enzyme = viewmodel.enzymes[index];
        return Column(
          children: [
            Visibility(
              visible: accountViewmodel.user!.userType == UserTypeEnum.user,
              replacement: Dismissible(
                key: Key(enzyme.id),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    viewmodel.enzymes.removeAt(index);
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
                          viewmodel.enzymes.insert(index, enzyme);
                          permanentlyDeleted = false;
                        });
                        // todoRepository.saveTodoList(todos);
                      },
                    ),
                    onDismissFunction: () async {
                      if (permanentlyDeleted) {
                        await viewmodel.deleteEnzyme(enzyme.id);
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
                    context.read<AccountViewmodel>().enableExcludeConfirmation!
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
            if (index == viewmodel.enzymes.length - 1)
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
    final viewmodel = context.watch<EnzymesViewmodel>();

    return EZTPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: viewmodel.loadEnzymes,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (viewmodel.enzymes.isNotEmpty &&
                viewmodel.state != StateEnum.loading)
              Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "🧬 ${viewmodel.enzymes.length} enzima${viewmodel.enzymes.length > 1 ? 's ' : ' '}encontrada${viewmodel.enzymes.length > 1 ? 's ' : ' '}",
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
