// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// 📦 Package imports:
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../../../../core/enums/enums.dart';
import '../../../../../../../core/failures/failures.dart';
import '../../../../../../../shared/ui/ui.dart';
import '../../../../viewmodel/fragments/treatments_viewmodel.dart';
import '../../../widgets/treatment_card.dart';

// 🌎 Project imports:

class TreatmentsPage extends StatefulWidget {
  const TreatmentsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<TreatmentsPage> createState() => _TreatmentsPageState();
}

class _TreatmentsPageState extends State<TreatmentsPage> {
  late final TreatmentsViewmodel _treatmentsViewmodel;
  final Key _refreshIndicatorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _treatmentsViewmodel = GetIt.I.get<TreatmentsViewmodel>();
    if (mounted) {
      _treatmentsViewmodel.addListener(
        () {
          if (mounted && _treatmentsViewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(_treatmentsViewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );
    }
  }

  Widget _buildTreatmentsList(double height) {
    if (_treatmentsViewmodel.state == StateEnum.error) {
      return const EZTForcedCenter(
        child: EZTError(
          message: 'Erro ao carregar tratamentos',
        ),
      );
    }

    if (_treatmentsViewmodel.state == StateEnum.loading) {
      return const EZTProgressIndicator(
        message: "Carregando tratamentos...",
      );
    }

    if (_treatmentsViewmodel.state == StateEnum.success &&
        _treatmentsViewmodel.treatments.isEmpty) {
      return const EZTForcedCenter(
        child: EZTNotFound(
          message: "Tratamentos não encontrados",
        ),
      );
    }

    return ListView.builder(
      controller: _treatmentsViewmodel.scrollController,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      itemCount: _treatmentsViewmodel.treatments.length,
      itemBuilder: (context, index) {
        var treatment = _treatmentsViewmodel.treatments[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Dismissible(
                key: Key(treatment.id),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    _treatmentsViewmodel.treatments.removeAt(index);
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
                          _treatmentsViewmodel.treatments
                              .insert(index, treatment);
                          permanentlyDeleted = false;
                        });
                        // todoRepository.saveTodoList(todos);
                      },
                    ),
                    onDismissFunction: () async {
                      if (permanentlyDeleted) {
                        await _treatmentsViewmodel
                            .deleteTreatment(treatment.id);
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
                /* confirmDismiss:
                    context.read<AccountViewmodel>().enableExcludeConfirmation!
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
                        : null, */
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
            if (index == _treatmentsViewmodel.treatments.length - 1)
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

    return EZTPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: _treatmentsViewmodel.fetch,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (_treatmentsViewmodel.treatments.isNotEmpty &&
                _treatmentsViewmodel.state != StateEnum.loading)
              Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "🧪 ${_treatmentsViewmodel.treatments.length} tratamento${_treatmentsViewmodel.treatments.length > 1 ? 's ' : ' '}encontrado${_treatmentsViewmodel.treatments.length > 1 ? 's ' : ' '}",
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
