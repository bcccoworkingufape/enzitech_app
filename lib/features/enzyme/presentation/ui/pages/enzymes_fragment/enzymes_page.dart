// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:get_it/get_it.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// 🌎 Project imports:
import '../../../../../../core/enums/enums.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../../../shared/ui/ui.dart';
import '../../../../../main/presentation/viewmodel/account_viewmodel.dart';
import '../../../../domain/entities/enzyme_entity.dart';
import '../../../viewmodel/enzymes_viewmodel.dart';
import '../../widgets/enzyme_card.dart';
import '../../widgets/enzymes_summary.dart';

class EnzymesPage extends StatefulWidget {
  const EnzymesPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EnzymesPage> createState() => _EnzymesPageState();
}

class _EnzymesPageState extends State<EnzymesPage> {
  late final AccountViewmodel _accountViewmodel;
  late final EnzymesViewmodel _enzymesViewmodel;

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
    _accountViewmodel = GetIt.I.get<AccountViewmodel>();
    _enzymesViewmodel = GetIt.I.get<EnzymesViewmodel>();

    if (mounted) {
      _enzymesViewmodel.addListener(
        () {
          if (mounted && _enzymesViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_enzymesViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  Widget _buildEnzymesList(double height) {
    if (_enzymesViewmodel.state == StateEnum.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar enzimas',
        ),
      );
    }

    if (_enzymesViewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(
        message: "Carregando enzimas...",
      );
    }

    if (_enzymesViewmodel.state == StateEnum.success &&
        _enzymesViewmodel.enzymes.isEmpty) {
      return EZTForcedCenter(
        child: EZTNotFound(
          message: _accountViewmodel.user!.userType == UserTypeEnum.admin
              ? "Nenhuma enzima cadastrada."
              : "Nenhuma enzima cadastrada, entre em contato com o seu Administrador para solucionar este problema.",
        ),
      );
    }

    return ListView.builder(
      controller: _enzymesViewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
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
                  // Remove the item from the data source.
                  setState(() {
                    _enzymesViewmodel.enzymes.removeAt(index);
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
                          _enzymesViewmodel.enzymes.insert(index, enzyme);
                          permanentlyDeleted = false;
                        });
                        // todoRepository.saveTodoList(todos);
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
                confirmDismiss: _accountViewmodel.enableExcludeConfirmation!
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
            if (index == _enzymesViewmodel.enzymes.length - 1)
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

    return AnimatedBuilder(
        animation: _enzymesViewmodel,
        builder: (context, child) {
          return EZTPullToRefresh(
            key: _refreshIndicatorKey,
            onRefresh: _enzymesViewmodel.fetch,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  if (_enzymesViewmodel.enzymes.isNotEmpty &&
                      _enzymesViewmodel.state != StateEnum.loading)
                    Column(
                      children: [
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "🧬 ${_enzymesViewmodel.enzymes.length} enzima${_enzymesViewmodel.enzymes.length > 1 ? 's ' : ' '}encontrada${_enzymesViewmodel.enzymes.length > 1 ? 's ' : ' '}",
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
        });
  }
}
