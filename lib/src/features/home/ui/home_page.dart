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
import 'package:enzitech_app/src/features/home/ui/fragments/account/ui/account_page.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/enzymes/ui/enzymes_page.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/experiments/ui/experiments_page.dart';
import 'package:enzitech_app/src/features/home/ui/fragments/treatments/ui/treatments_page.dart';
import 'package:enzitech_app/src/features/home/viewmodel/home_viewmodel.dart';
import 'package:enzitech_app/src/shared/business/domain/enums/enums.dart';
import 'package:enzitech_app/src/shared/ui/ui.dart';
import 'package:enzitech_app/src/shared/utilities/utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final HomeViewmodel viewmodel;

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
    viewmodel = context.read<HomeViewmodel>();

    if (mounted) {
      setAllButtonsVisible();
      initFragements();

      viewmodel.addListener(
        () {
          if (viewmodel.state == StateEnum.error) {
            EZTSnackBar.show(
              context,
              HandleFailure.of(viewmodel.failure!),
              eztSnackBarType: EZTSnackBarType.error,
            );
          }
        },
      );

      viewmodel.experimentsViewmodel.scrollController.addListener(() {
        if (viewmodel.experimentsViewmodel.scrollController.position
                .userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleExperimentButton == true && mounted) {
            setState(() {
              _isVisibleExperimentButton = false;
            });
          }
        }
        if (viewmodel.experimentsViewmodel.scrollController.position
                .userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleExperimentButton == false && mounted) {
            setState(() {
              _isVisibleExperimentButton = true;
            });
          }
        }
      });

      viewmodel.treatmentsViewmodel.scrollController.addListener(() {
        if (viewmodel.treatmentsViewmodel.scrollController.position
                .userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleTreatmentButton == true && mounted) {
            setState(() {
              _isVisibleTreatmentButton = false;
            });
          }
        }
        if (viewmodel.treatmentsViewmodel.scrollController.position
                .userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisibleTreatmentButton == false && mounted) {
            setState(() {
              _isVisibleTreatmentButton = true;
            });
          }
        }
      });

      viewmodel.enzymesViewmodel.scrollController.addListener(() {
        if (viewmodel.enzymesViewmodel.scrollController.position
                .userScrollDirection ==
            ScrollDirection.reverse) {
          if (_isVisibleEnzymeButton == true && mounted) {
            setState(() {
              _isVisibleEnzymeButton = false;
            });
          }
        }
        if (viewmodel.enzymesViewmodel.scrollController.position
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
        homeViewmodel: viewmodel,
      ),
      TreatmentsPage(
        homeViewmodel: viewmodel,
      ),
      EnzymesPage(
        homeViewmodel: viewmodel,
      ),
      AccountPage(
        homeViewmodel: viewmodel,
      ),
    ];
  }

  Widget? get dealWithFloatingActionButton {
    if (viewmodel.fragmentIndex == 0 && _isVisibleExperimentButton) {
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

    if (viewmodel.fragmentIndex == 1 && _isVisibleTreatmentButton) {
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

    if (viewmodel.accountViewmodel.user != null) {
      if (viewmodel.fragmentIndex == 2 &&
          viewmodel.accountViewmodel.user!.userType == UserTypeEnum.admin &&
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
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          AppSvgs.logo,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      body: Consumer(builder: (context, _, __) {
        if (viewmodel.state == StateEnum.loading) {
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

        return _fragments[viewmodel.fragmentIndex];
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
        currentIndex: viewmodel.fragmentIndex,
        selectedItemColor: AppColors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: AppColors.primary,
        onTap: (index) {
          setAllButtonsVisible();
          int beforeSet = viewmodel.fragmentIndex;
          viewmodel.setFragmentIndex(index);
          if (index == 0 &&
              beforeSet == 0 &&
              viewmodel.experimentsViewmodel.scrollController.hasClients) {
            viewmodel.experimentsViewmodel.scrollController.animateTo(
              viewmodel.experimentsViewmodel.scrollController.position
                      .minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          } else if (index == 1 &&
              beforeSet == 1 &&
              viewmodel.treatmentsViewmodel.scrollController.hasClients) {
            viewmodel.treatmentsViewmodel.scrollController.animateTo(
              viewmodel.treatmentsViewmodel.scrollController.position
                      .minScrollExtent +
                  (kBottomNavigationBarHeight / 10000),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.fastOutSlowIn,
            );
          } else if (index == 2 &&
              beforeSet == 2 &&
              viewmodel.enzymesViewmodel.scrollController.hasClients) {
            viewmodel.enzymesViewmodel.scrollController.animateTo(
              viewmodel.enzymesViewmodel.scrollController.position
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
