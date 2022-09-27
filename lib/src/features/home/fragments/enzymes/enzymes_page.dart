// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/components/enzyme_card.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_controller.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_pull_to_refresh.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

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
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height / 1.75,
              child: const Center(
                child: Text("Erro ao carregar enzimas"),
              ),
            ),
          ],
        ),
      );
    }

    if (controller.state == EnzymesState.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.state == EnzymesState.success &&
        controller.enzymes.isEmpty) {
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
      itemCount: controller.enzymes.length,
      itemBuilder: (context, index) {
        var enzyme = controller.enzymes[index];
        return Visibility(
          visible: accountController.user!.userType == UserTypeEnum.user,
          replacement: Dismissible(
            key: Key(enzyme.id),
            onDismissed: (direction) {
              controller.deleteEnzyme(enzyme.id);

              // Remove the item from the data source.
              setState(() {
                controller.enzymes.removeAt(index);
              });

              EZTSnackBar.clear(context);

              EZTSnackBar.show(
                context,
                '${enzyme.name} excluído!',
                eztSnackBarType: EZTSnackBarType.error,
              );

              // Then show a snackbar.
              // ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('${experiment.name} excluído!')));
            },
            // Show a red background as the item is swiped away.
            background: Container(color: Colors.red),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: EnzymeCard(
                enzyme: enzyme,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: EnzymeCard(
                enzyme: enzyme,
              ),
            ),
          ),
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
            const SizedBox(
              height: 16,
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
