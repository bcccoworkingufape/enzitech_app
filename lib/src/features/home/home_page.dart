// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/components/experiment_card.dart';
import 'package:enzitech_app/src/features/home/fragments/account/account_page.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_page.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_page.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  final List<Widget> _fragments = const [
    ExperimentsPage(),
    TreatmentsPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();
    if (mounted) {
      controller.addListener(() {
        if (controller.state == HomeState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(controller.failure!.message),
            ),
          );
        }
      });
    }
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
      floatingActionButton: controller.fragmentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                //TODO: REMOVER ESTE TESTE
                if (controller.mockedList.isEmpty) {
                  controller.setMockedList([
                    ExperimentCard(
                      name: 'Experimento 1',
                      modifiedAt: DateTime.now(),
                      description:
                          'Esta é uma descrição opcional muito grande de experimento, bem detalhado, com muitas linhas, onde será permitido no máximo quatro linhas...',
                      progress: .55,
                    ),
                  ]);
                } else {
                  controller.setMockedList([]);
                }
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
            )
          : null,
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
