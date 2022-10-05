// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/treatments/components/treatment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/themes/app_text_styles.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_not_founded.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_pull_to_refresh.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

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
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.75,
              child: const Center(
                child: Text("Erro ao carregar tratamentos"),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.state == TreatmentsState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state == TreatmentsState.success &&
        controller.treatments.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.65,
              child: const EZTNotFounded(
                message: "Tratamentos não encontrados",
              ),
            ),
          ],
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
                  controller.deleteTreatment(treatment.id);

                  // Remove the item from the data source.
                  setState(() {
                    controller.treatments.removeAt(index);
                  });

                  EZTSnackBar.clear(context);

                  EZTSnackBar.show(
                    context,
                    '${treatment.name} excluído!',
                    eztSnackBarType: EZTSnackBarType.error,
                  );
                },
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
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
