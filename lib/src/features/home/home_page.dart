// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/account/account_page.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_page.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_controller.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_page.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';
import '../../shared/routes/route_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;
  late final ExperimentsController experimentsController;
  late final TreatmentsController treatmentsController;
  late final AccountController accountController;

  late List<Widget> _fragments;

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    experimentsController = context.read<ExperimentsController>();
    treatmentsController = context.read<TreatmentsController>();
    accountController = context.read<AccountController>();
    initFragements();
    if (mounted) {
      Future.delayed(Duration.zero, () async {
        await experimentsController.loadExperiments();
        await treatmentsController.loadTreatments();
        await accountController.loadAccount();
      });
      controller.addListener(
        () {
          if (controller.state == HomeState.error) {
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

  initFragements() {
    _fragments = [
      ExperimentsPage(
        homeController: controller,
      ),
      TreatmentsPage(
        homeController: controller,
      ),
      AccountPage(
        homeController: controller,
      ),
    ];
  }

  Widget? get dealWithFloatingActionButton {
    if (controller.fragmentIndex == 0) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.createExperiment,
          );
        },
        label: Text(
          "Cadastrar\nexperimento",
          style: TextStyles.buttonBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          color: AppColors.white,
          size: 30,
        ),
      );
    }

    if (controller.fragmentIndex == 1) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            RouteGenerator.createTreatment,
          );
        },
        label: Text(
          "Cadastrar\ntratamento",
          style: TextStyles.buttonBackground,
        ),
        icon: const Icon(
          PhosphorIcons.pencilLine,
          color: AppColors.white,
          size: 30,
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      body: ChangeNotifierProvider(
        create: (BuildContext context) {},
        child: _fragments[controller.fragmentIndex],
      ),
      floatingActionButton: dealWithFloatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.flask),
            label: 'Experimentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.testTube),
            label: 'Tratamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.userCircleGear),
            label: 'Conta',
          ),
        ],
        currentIndex: controller.fragmentIndex,
        selectedItemColor: AppColors.white,
        backgroundColor: AppColors.primary,
        onTap: (index) => controller.setFragmentIndex(index),
      ),
    );
  }
}
