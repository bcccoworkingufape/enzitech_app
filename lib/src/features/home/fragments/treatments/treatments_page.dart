// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/treatments/components/treatment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
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
                child: Text("Erro ao carregar experimentos"),
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
              height: height / 1.35,
              child: const Center(
                child: Text("Tratamentos não encontrados"),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: controller.treatments.length,
      itemBuilder: (context, index) {
        var treatment = controller.treatments[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: TreatmentCard(
            name: treatment.name,
            createdAt: treatment.createdAt,
            description: treatment.description,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthMQ = MediaQuery.of(context).size.width;
    var heightMQ = MediaQuery.of(context).size.height;
    final controller = context.watch<TreatmentsController>();

    return EZTPullToRefresh(
      key: _refreshIndicatorKey,
      onRefresh: controller.loadTreatments,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
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
