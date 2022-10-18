// 🎯 Dart imports:
import 'dart:math' as math;

// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// 📦 Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:enzitech_app/src/features/home/fragments/account/account_page.dart';
import 'package:enzitech_app/src/features/home/fragments/enzymes/enzymes_page.dart';
import 'package:enzitech_app/src/features/home/fragments/experiments/experiments_page.dart';
import 'package:enzitech_app/src/features/home/fragments/treatments/treatments_page.dart';
import 'package:enzitech_app/src/features/home/home_controller.dart';
import 'package:enzitech_app/src/shared/failures/failures.dart';
import 'package:enzitech_app/src/shared/models/user_model.dart';
import 'package:enzitech_app/src/shared/routes/route_generator.dart';
import 'package:enzitech_app/src/shared/themes/app_complete_theme.dart';
import 'package:enzitech_app/src/shared/widgets/ezt_snack_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final HomeController controller;
  late final AnimationController animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  late List<Widget> _fragments;

  var _isVisibleExperimentButton; // ignore: prefer_typing_uninitialized_variables
  var _isVisibleTreatmentButton; // ignore: prefer_typing_uninitialized_variables
  var _isVisibleEnzymeButton; // ignore: prefer_typing_uninitialized_variables

  @override
  void initState() {
    super.initState();
    controller = context.read<HomeController>();

    if (mounted) {
      setAllButtonsVisible();
      initFragements();

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

      controller.experimentsController.scrollController.addListener(() {
        if (controller.experimentsController.scrollController.position
                .userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleExperimentButton == true && mounted) {
            setState(() {
              _isVisibleExperimentButton = false;
            });
          }
        }
        if (controller.experimentsController.scrollController.position
                .userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleExperimentButton == false && mounted) {
            setState(() {
              _isVisibleExperimentButton = true;
            });
          }
        }
      });

      controller.treatmentsController.scrollController.addListener(() {
        if (controller.treatmentsController.scrollController.position
                .userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleTreatmentButton == true && mounted) {
            setState(() {
              _isVisibleTreatmentButton = false;
            });
          }
        }
        if (controller.treatmentsController.scrollController.position
                .userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleTreatmentButton == false && mounted) {
            setState(() {
              _isVisibleTreatmentButton = true;
            });
          }
        }
      });

      controller.enzymesController.scrollController.addListener(() {
        if (controller.enzymesController.scrollController.position
                .userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleEnzymeButton == true && mounted) {
            setState(() {
              _isVisibleEnzymeButton = false;
            });
          }
        }
        if (controller.enzymesController.scrollController.position
                .userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleEnzymeButton == false && mounted) {
            setState(() {
              _isVisibleEnzymeButton = true;
            });
          }
        }
      });
    }
  }

  setAllButtonsVisible() {
    if (mounted) {
      setState(() {
        _isVisibleExperimentButton = true;
        _isVisibleTreatmentButton = true;
        _isVisibleEnzymeButton = true;
      });
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
      EnzymesPage(
        homeController: controller,
      ),
      AccountPage(
        homeController: controller,
      ),
    ];
  }

  Widget? get dealWithFloatingActionButton {
    if (controller.fragmentIndex == 0 && _isVisibleExperimentButton) {
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

    if (controller.fragmentIndex == 1 && _isVisibleTreatmentButton) {
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

    if (controller.accountController.user != null) {
      if (controller.fragmentIndex == 2 &&
          controller.accountController.user!.userType == UserTypeEnum.admin &&
          _isVisibleEnzymeButton) {
        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.createEnzyme,
            );
          },
          label: Text(
            "Cadastrar\nenzima",
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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AppSvgs.logo,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      body: Consumer(builder: (context, _, __) {
        if (controller.state == HomeState.loading) {
          return Center(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (_, child) {
                return Transform.rotate(
                  angle: animationController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: SvgPicture.asset(
                AppSvgs.iconLogo,
                alignment: Alignment.center,
                width: 75,
              ),
            ),
          );
        }

        return _fragments[controller.fragmentIndex];
      }),
      floatingActionButton: dealWithFloatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.flask),
            label: 'Experimentos',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.testTube),
            label: 'Tratamentos',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.atom),
            label: 'Enzimas',
            backgroundColor: AppColors.primary,
          ),
          BottomNavigationBarItem(
            icon: Icon(PhosphorIcons.userCircleGear),
            label: 'Conta',
            backgroundColor: AppColors.primary,
          ),
        ],
        currentIndex: controller.fragmentIndex,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppColors.primary,
        onTap: (index) {
          setAllButtonsVisible();
          int beforeSet = controller.fragmentIndex;
          controller.setFragmentIndex(index);
          if (index == 0 &&
              beforeSet == 0 &&
              controller.experimentsController.scrollController.hasClients) {
            controller.experimentsController.scrollController.animateTo(
              controller.experimentsController.scrollController.position
                      .minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          } else if (index == 1 &&
              beforeSet == 1 &&
              controller.treatmentsController.scrollController.hasClients) {
            controller.treatmentsController.scrollController.animateTo(
              controller.treatmentsController.scrollController.position
                      .minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          } else if (index == 2 &&
              beforeSet == 2 &&
              controller.enzymesController.scrollController.hasClients) {
            controller.enzymesController.scrollController.animateTo(
              controller.enzymesController.scrollController.position
                      .minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          }
        },
      ),
    );
  }
}
